--ORACLE DBS TABLE CREATION I have added all the commands to this file to make it easier to read
CREATE TABLE CLIENT (
ClientNo VARCHAR2 (10) NOT NULL,
ClientName VARCHAR2 (30) NOT NULL,
Adress VARCHAR2 (50) NOT NULL,
Sex Char (1) NOT NULL CHECK (Sex = 'M' or Sex = 'F' or Sex = 'O'),
Email VARCHAR2 (30) NOT NULL,
Spouse VARCHAR2 (30),
DOB DATE, 
Occupation VARCHAR2 (30),
Anniversary DATE,
Phone NUMBER (10) NOT NULL,
MaritalStatus Char (1) CHECK (MaritalStatus = 'Y' or MaritalStatus = 'N'),
ResNo VARCHAR2 (10) NOT NULL REFERENCES RESERVATION(ResNo),
PRIMARY KEY (ClientNo)
--FOREIGN KEY (ResNo) REFERENCES RESERVATION(ResNo)
);

CREATE TABLE RESERVATION (
ResNo VARCHAR2 (10) NOT NULL,
NoOfGuests NUMBER (2) NOT NULL,
StartDate DATE NOT NULL,
EndDate DATE NOT NULL,
ResDate DATE NOT NULL,
Status VARCHAR2 (10) NOT NULL,
PRIMARY KEY (ResNo));
CREATE TABLE ACCOMMODATION (
RoomNo NUMERIC (3) NOT NULL,
AccStatus VARCHAR2 (10) NOT NULL CHECK (AccStatus = 'Available' or AccStatus = 'Occupied'), 
LevelNo NUMERIC (1) NOT NULL,
PRIMARY KEY (RoomNo)
);

CREATE TABLE ACCOMMODATIONTYPE (
AccTypeID VARCHAR2(10) NOT NULL,
NoOfBeds NUMERIC (1) NOT NULL,
AccTypeName VARCHAR (20) NOT NULL,
AcctypeRate NUMERIC (4) NOT NULL, 
RoomNo NUMERIC (3) NOT NULL REFERENCES ACCOMMODATION(RoomNo),
PRIMARY KEY (AccTypeID)
);

CREATE TABLE ACTIVITY ( 
ActivityID VARCHAR2 (10) NOT NULL,
ActName VARCHAR2 (20) NOT NULL,
ActDescription VARCHAR2 (255),
ActRate NUMERIC (4, 2) NOT NULL,
RiskLevel VARCHAR2 (10) NOT NULL CHECK (RiskLevel = 'Low' or RiskLevel = 'Medium' or RiskLevel = 'high' or RiskLevel = 'VeryHigh'),
Location VARCHAR2 (20) NOT NULL,
OpeningHours DATE, --Not all activities had exact times, so check constraint was not used.
ActivityType VARCHAR2 (14) NOT NULL CHECK (ActivityType = 'Outdoor' or ActivityType = 'Indoor'),
Primary Key (ActivityID));

CREATE TABLE ACTIVITYSUPERVISOR (
SupervisorID VARCHAR2 (10) NOT NULL,
PRIMARY KEY (SupervisorID));

CREATE TABLE SWIMMINGINSTRUCTOR (
SwimmerID VARCHAR2 (10) NOT NULL,
SwimName VARCHAR2 (20) NOT NULL,
SwimPhone NUMERIC (10) NOT NULL,
SupervisorID VARCHAR2 (10) REFERENCES ACTIVITYSUPERVISOR(SupervisorID),
PRIMARY KEY (SwimmerID));

CREATE TABLE MASSEUSE (
MassuseID VARCHAR2 (10) NOT NULL,
MassName VARCHAR2 (20) NOT NULL,
Area VARCHAR2 (20) NOT NULL,
MassPhone NUMERIC (10) NOT NULL,
SupervisorID VARCHAR2 (10) REFERENCES ACTIVITYSUPERVISOR(SupervisorID),
PRIMARY KEY (MassuseID));

CREATE TABLE OUTDOORINSTRUCTOR (
InstructorID VARCHAR2 (10) NOT NULL,
InstrName VARCHAR2 (20) NOT NULL,
Field VARCHAR2 (20) NOT NULL,
InstrPhone NUMERIC (10) NOT NULL,
SupervisorID VARCHAR2 (10) REFERENCES ACTIVITYSUPERVISOR(SupervisorID),
PRIMARY KEY (InstructorID));

CREATE TABLE EQUIPMENT (
EqiupmentID VARCHAR2 (10) NOT NULL,
EquipName VARCHAR2 (30) NOT NULL,
Stock NUMERIC (4) NOT NULL,
NextInspection DATE, 
PRIMARY KEY (EqiupmentID));

CREATE TABLE SUPPLIER (
BillerCode VARCHAR2 (10) NOT NULL,
BusinessName VARCHAR2 (30) NOT NULL,
Phone NUMERIC (10) NOT NULL,
ContactPerson VARCHAR2 (20) NOT NULL,
PRIMARY KEY (BillerCode));

CREATE TABLE SUPPLIES (
EquipmentID VARCHAR2 (10) NOT NULL REFERENCES EQUIPMENT(EqiupmentID),
BillerCode VARCHAR2 (10) NOT NULL REFERENCES SUPPLIER(BillerCode),
PRIMARY KEY (EquipmentID, BillerCode));

CREATE TABLE USES (
EquipmentID VARCHAR2 (10) NOT NULL REFERENCES EQUIPMENT(EqiupmentID),
ActivityID VARCHAR2 (10) NOT NULL REFERENCES ACTIVITY(ActivityID),
PRIMARY KEY (EquipmentID, ActivityID));

CREATE TABLE PREFERS (
ClientNo VARCHAR2 (10) NOT NULL REFERENCES CLIENT(ClientNo),
ActivityID VARCHAR2 (10) NOT NULL REFERENCES ACTIVITY(ActivityID),
PRIMARY KEY (ClientNo, ActivityID));

CREATE TABLE CONDITIONS (
ClientNo VARCHAR2 (10) NOT NULL REFERENCES CLIENT(ClientNo),
Conditions VARCHAR2 (20) NOT NULL,
PRIMARY KEY (ClientNo, Conditions));

CREATE TABLE FIELD (
InstructorID VARCHAR2 (10) NOT NULL REFERENCES OUTDOORINSTRUCTOR(InstructorID),
Field VARCHAR2 (20) NOT NULL,
PRIMARY KEY (InstructorID, Field));

CREATE TABLE SUPERVISES (
ActivityID VARCHAR2 (10) NOT NULL REFERENCES ACTIVITY(ActivityID),
ResNo VARCHAR2 (10) NOT NULL REFERENCES RESERVATION (ResNo),
SupervisorID VARCHAR2 (10) NOT NULL REFERENCES ACTIVITYSUPERVISOR (SupervisorID),
Day VARCHAR2 (8), 
Time DATE,
PRIMARY KEY (ActivityID, ResNo, SupervisorID));

/*INSERT STATEMENTS*/
INSERT INTO ACCOMMODATION (ROOMNO, ACCSTATUS, LEVELNO)
VALUES (101, 'Available', 1);

INSERT INTO ACCOMMODATIONTYPE (ACCTYPEID, NOOFBEDS, ACCTYPENAME, ACCTYPERATE, ROOMNO)
VALUES ('Honeymoon', 1, 'The Honey Moon Suite', 100, 101);

INSERT INTO RESERVATION(RESNO, NOOFGUESTS, STARTDATE, ENDDATE, RESDATE, STATUS)
VALUES('0000000001', 1, TO_DATE('2023-11-21','YYYY-MM-DD'), TO_DATE('2023-11-24','YYYY-MM-DD'), TO_DATE('2023-10-17','YYYY-MM-DD'), 'Booked');

INSERT INTO CLIENT (ClientNo, CLIENTNAME, Adress, Sex, Email, Spouse, DOB, Occupation, Anniversary, Phone, MaritalStatus, ResNo)
VALUES ('0000000001', 'Tom Smith', '1234 Fake Street Victoria 3000', 'M', 'tsmith@outlook.com', 'Helen Smith',TO_DATE('1980-11-21','YYYY-MM-DD') ,'Electritian', TO_DATE('2002-11-21','YYYY-MM-DD'), 0415675822,'Y', '0000000001');
INSERT INTO ACCOMMODATIONTYPE
VALUES ('Honeymoon', 1, 'The Honey Moon Suite', 100, 101);

INSERT INTO ACTIVITY
VALUES ('Swimming01', 'Swimming', 'A heated swimming pool that includes diving boards and different water levels.', 25, 'Medium', 'Indoor', TO_DATE('2000-01-01 08:00:00 AM', 'YYYY-MM-DD HH:MI:SS AM'), 'Indoor' );

INSERT INTO ACTIVITYSUPERVISOR (SUPERVISORID)
VALUES ('Sup0001');
INSERT INTO ACTIVITYSUPERVISOR (SUPERVISORID)
VALUES ('Sup0002');
INSERT INTO ACTIVITYSUPERVISOR (SUPERVISORID)
VALUES ('Sup0003');

INSERT INTO CONDITIONS 
VALUES ('0000000001', 'Asthma');

INSERT INTO EQUIPMENT 
VALUES ('1122334455', 'Rope', 100, current_date);

INSERT INTO OUTDOORINSTRUCTOR 
VALUES ('Out0001', 'Sam Smith', 'Rock Climbing', 0402442269,'Sup0001' );

INSERT INTO FIELD 
VALUES ('Out0001', 'RockClimbing');

INSERT INTO MASSEUSE 
VALUES ('Mas0001', 'Lex Luthor', 'Deep Tissue', 0449113141, 'Sup0002');

/*PREFERS*/

INSERT INTO SWIMMINGINSTRUCTOR 
VALUES ('Swm0001', 'Lanna Tron', 0449188141, 'Sup0003');

INSERT INTO PREFERS 
VALUES ('0000000001', 'Swimming01');

INSERT INTO SUPPLIER 
VALUES ('0011001100', 'EqptOutdoors', 0442883499,'Will Wilson');

INSERT INTO SUPPLIES 
VALUES ('1122334455', '0011001100');

INSERT INTO USES 
VALUES ('1122334455', 'Swimming01');
