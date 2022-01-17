void setup() {
  pinMode(12, OUTPUT);
  digitalWrite(12, 1);
  // put your setup code here, to run once:

   Serial.begin(9600);

 Serial.setTimeout(1);

}

void loop() {
  // put your main code here, to run repeatedly:
  int a0 = analogRead(A0);
  int a1 = analogRead(A1);
  int a2 = analogRead(A2);
  int a3 = analogRead(A3);
  int a4 = analogRead(A0);
  int a5 = analogRead(A1);
  int a6 = analogRead(A2);
  int a7 = analogRead(A3);

  Serial.print(a0); Serial.print(" ");
  Serial.print(a1); Serial.print(" ");
  Serial.print(a2); Serial.print(" ");
  Serial.print(a3); Serial.print(" ");
  Serial.print(a4); Serial.print(" ");
  Serial.print(a5); Serial.print(" ");
  Serial.print(a6); Serial.print(" ");
  Serial.print(a7); Serial.print(" ");
  Serial.println();

  delay(100);


}
