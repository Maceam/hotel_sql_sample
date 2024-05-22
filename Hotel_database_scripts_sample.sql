/*Assignment 3 Maysam Asafiri
Question 1*/

/*Task 1*/

/*1.1
Display the name of the client who has made the most reservations with Getaway Holidays.*/

SELECT c.Name
FROM Client c, Reservation r
Where c.ClientNo = r.ClientNo
GROUP BY c.Name
HAVING COUNT(*) = (
  SELECT COUNT(*) AS ReservationCount
  FROM Reservation
  GROUP BY ClientNo
  ORDER BY ReservationCount DESC
  FETCH NEXT 1 ROWS ONLY
);

/*1.2
Display the name of the client who has booked a reservation for the longest period.*/

SELECT c.Name, MAX(r.enddate - r.startdate) AS MaxDays
FROM Client c, Reservation r
WHERE c.ClientNo = r.ClientNo
GROUP BY c.Name
ORDER BY Maxdays DESC
FETCH NEXT 1 ROWS ONLY;

/*1.3
Display the room number, room type, room rate and number of guests for the reservation made by client(s)
having last name ‘Perez’.*/

SELECT ra.ROOMNO, at.ACCTYPENAME, at.ACCTYPERATE, r.NOOFGUESTS
FROM RESERVATION r
INNER JOIN Client c ON r.RESNO = c.CLIENTNO
INNER JOIN RESERVATION_ACCOMMODATION ra ON ra.resno = r.resno
INNER JOIN ACCOMMODATION a ON ra.ROOMNO = a.ROOMNO
INNER JOIN ACCOMMODATION_TYPE at ON at.ACCTYPEID = a.ACCTYPEID
WHERE c.name LIKE '%Perez';

/*1.4
Display the name of the outdoor instructor who has the most duties as an activity supervisor.*/
SELECT oi.INSTRNAME
FROM OUTDOOR_ACTIVITY oa
LEFT OUTER JOIN SUPERVISION s ON oa.ACTIVITYID = s.ACTIVITYID
INNER JOIN OUTDOOR_INSTRUCTOR oi ON s.SUPERVISORID = oi.SUPERVISORID
GROUP BY oi.INSTRNAME
HAVING COUNT(s.ACTIVITYID) = (
  SELECT COUNT(*) AS highestNum
    FROM OUTDOOR_ACTIVITY oa
    LEFT OUTER JOIN SUPERVISION s ON oa.ACTIVITYID = s.ACTIVITYID
    GROUP BY SUPERVISORID
    ORDER BY highestNum DESC
    FETCH NEXT 1 ROWS ONLY
);

/*1.5
Display the reservations (reservation number and duration) whose duration is greater than
the average duration of reservations.*/
SELECT MAX(r.enddate - r.startdate) AS MaxDays
FROM Reservation r
GROUP BY r.resno
HAVING MAX(r.enddate - r.startdate) > (SELECT AVG(r.enddate - r.startdate) AS AvgDays FROM Reservation r)
ORDER BY MaxDays DESC;

/*Task 2 a.
Write a stored procedure that displays the contact details of clients who do not have any
heart conditions or acrophobia. The resort wants to promote a new outdoor activity to them. */
CREATE OR REPLACE PROCEDURE CUSTOMERCONTACT;
DECLARE
   CURSOR C_customercontact IS
      SELECT c.clientNo, c.name, c.phone, c.email
      FROM Client c
      LEFT OUTER JOIN CCONDITION con ON c.clientNo = con.clientNo
      WHERE con.Condition NOT LIKE '%Heart Condition%' AND con.Condition NOT LIKE '%Acrophobia%' OR con.Condition IS NULL;
   v_clientNo VARCHAR2(10);
   v_name VARCHAR2(20);
   v_phone VARCHAR2(20);
   v_email VARCHAR2(50);
BEGIN
   OPEN C_customercontact;
   LOOP
      FETCH C_customercontact INTO v_clientNo, v_name, v_phone, v_email;
      EXIT WHEN C_customercontact%NOTFOUND;
      dbms_output.put_line(v_clientNo || ' ' || v_name || ' ' || v_phone || ' ' || v_email);
   END LOOP;
   CLOSE C_customercontact;
END

/*TEST PROCEDURE */

BEGIN
CUSTOMERCONTACT;
END

/*Task 2 b.
Write a stored function that uses the reservation number, activity ID and date as input and returns the name of the supervisor assigned for that specific activity. */

CREATE OR REPLACE FUNCTION ActingSupervisor;
CREATE OR REPLACE FUNCTION ActingSupervisor(
p_reservationnumber supervision.resno%type,
p_activity supervision.activityID%type,
p_date supervision.day%type)
RETURN VARCHAR2 IS
v_activitysupervisor VARCHAR2(20);
  v_outdoorname OUTDOOR_INSTRUCTOR.instrname%TYPE;
  v_massname MASSEUSE.massname%TYPE;
  v_swimname SWIMMING_INSTRUCTOR.swimname%TYPE;
BEGIN
SELECT SupervisorID
    INTO v_activitysupervisor
    FROM SUPERVISION
    WHERE resno = p_reservationnumber AND activityid = p_activity AND TRUNC(day) = TRUNC(p_date)
    ORDER BY SupervisorID DESC
    FETCH NEXT 1 ROWS ONLY;

    SELECT INSTRNAME
        INTO v_outdoorname
        FROM OUTDOOR_INSTRUCTOR
        WHERE SupervisorID = v_activitysupervisor
        AND ROWNUM = 1;
    
    IF v_outdoorname IS NOT NULL THEN
    RETURN v_outdoorname;
    ELSE

    SELECT MASSNAME
        INTO v_massname
        FROM MASSEUSE
        WHERE SupervisorID = v_activitysupervisor
        AND ROWNUM = 1;

    IF v_massname IS NOT NULL THEN
    RETURN v_massname;
    ELSE

    SELECT SWIMNAME
        INTO v_swimname
        FROM SWIMMING_INSTRUCTOR
        WHERE SupervisorID = v_activitysupervisor
        AND ROWNUM = 1;

    IF v_swimname IS NOT NULL THEN
    RETURN v_swimname;

    ELSE
    RETURN NULL;
END IF;
END IF;
END IF;
END

/*TEST FUNCTION*/
SELECT ActingSupervisor(14, 7, TO_DATE('20-05-2016', 'DD-MM-YYYY')) FROM dual;

/*Task 3*/
CREATE OR REPLACE TRIGGER aquaphobia
BEFORE INSERT
ON CLIENT_PREFERENCE
FOR EACH ROW
DECLARE
  v_condition VARCHAR2(20);
BEGIN
  SELECT c.condition 
  INTO v_condition
  FROM CCONDITION c 
  WHERE c.clientNo = :new.clientNo;

  IF :new.ACTIVITYID = '7' AND v_condition = 'aquaphobia' THEN
    RAISE_APPLICATION_ERROR(-20023, 'Error due to having aquaphobia, you cannot select rafting');
  END IF;
END aquaphobia;

Trigger
INSERT INTO CLIENT_PREFERENCE VALUES ('7','7');



