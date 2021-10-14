# python logger.py --port COM3 --left1 left1.txt --right1 right1.txt --left2 left2.txt --right2 right2.txt --raw raw.txt --duration 60


import sys
sys.path.insert(0, u'C:/Python310/Lib/site-packages')
import threading
import serial
import argparse
import time

raw_data = []
sample = True


def getSignedNumber(number, bitLength):
    mask = (2 ** bitLength) - 1
    if number & (1 << (bitLength - 1)):
        return number | ~mask
    else:
        return number & mask


def normalize_raw(data):
    if len(data) >= 4:
        if (data[0] & 128) == (data[1] & 128):
            if (data[1] & 128) == (data[2] & 128):
                if (data[2] & 128) == (data[3] & 128):
                    return data
                else:
                    return normalize_raw(data[3:])
            else:
                return normalize_raw(data[2:])
        else:
            return normalize_raw(data[1:])
    return data


def parse_raw(data):
    res = [[], [], [], []]

    data = normalize_raw(data)
    while len(data) % 4 > 0:
        data.pop(-1)

    for i in range(0, len(data), 4):
        channel = (data[i + 3] & 0xC0) >> 6

        res_0   = (data[i + 3] & 0x3F) <<  0
        res_1   = (data[i + 2] & 0x3F) <<  6
        res_2   = (data[i + 1] & 0x3F) << 12
        res_3   = (data[i    ] & 0x3F) << 18

        res[channel].append(getSignedNumber(res_3 | res_2 | res_1 | res_0, 24))

    return res


def receive_data(ser):
    global raw_data, sample

    while sample:
        if ser.inWaiting() > 0:
            raw_data.append(int(ser.read().encode('hex'), 16))


def dump_data(args):
    global raw_data, sample
    sample = False

    args.raw.write(bytearray(raw_data))

    parsedData = parse_raw(raw_data)

    for item in parsedData[0]:
        args.right1.write("%s\n" % item)
    for item in parsedData[1]:
        args.left1.write("%s\n" % item)
    for item in parsedData[2]:
        args.right2.write("%s\n" % item)
    for item in parsedData[3]:
        args.left2.write("%s\n" % item)

    args.raw.close()
    args.left1.close()
    args.right1.close()
    args.left2.close()
    args.right2.close()

    sys.exit()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Headsense Logger v2")
    parser.add_argument('--port',     nargs='?', type=str,                     default=None,       required=False, help="Serial Port number")
    parser.add_argument('--duration', nargs='?', type=int,                     default=10,         required=False, help="Sampling time in seconds, default 10 s")
    parser.add_argument('--raw',      nargs='?', type=argparse.FileType('wb'), default=sys.stdout, required=False, help="Sampled raw log file, default STDOUT")
    parser.add_argument('--left1',    nargs='?', type=argparse.FileType('wb'), default=sys.stdout, required=False, help="Sampled log file for left channel for first amplifier, default STDOUT")
    parser.add_argument('--right1',   nargs='?', type=argparse.FileType('wb'), default=sys.stdout, required=False, help="Sampled log file for right channel for first amplifier, default STDOUT")
    parser.add_argument('--left2',    nargs='?', type=argparse.FileType('wb'), default=sys.stdout, required=False, help="Sampled log file for left channel for second amplifier, default STDOUT")
    parser.add_argument('--right2',   nargs='?', type=argparse.FileType('wb'), default=sys.stdout, required=False, help="Sampled log file for right channel for second amplifier, default STDOUT")

    args = parser.parse_args()

    ser = serial.Serial(port=args.port, baudrate=19200)

    threading.Thread(target=receive_data, args=(ser,)).start()
    threading.Timer(args.duration + 5, dump_data, (args,)).start()

