USE [QueensCollegeScheduleSpring2019]

-- Show all instructors who are teaching in classes in multiple departments.
SELECT I.InstructorId
	,I.InstructorFullName
	,COUNT(DI.DepartmentId) AS NumberOfDepartments
FROM [Bridge].[DepartmentInstructor] AS DI
INNER JOIN [QC].[Instructor] AS I ON DI.InstructorId = I.InstructorId
GROUP BY I.InstructorId
	,I.InstructorFullName
HAVING COUNT(DI.DepartmentId) > 1;

-- How many instructors are in each department?
SELECT D.DepartmentName
	,COUNT(I.InstructorId) AS NumberOfInstructors
FROM [Bridge].[DepartmentInstructor] AS DI
INNER JOIN [QC].[Instructor] AS I ON DI.InstructorId = I.InstructorId
INNER JOIN [QC].[Department] AS D ON DI.DepartmentId = D.DepartmentId
GROUP BY D.DepartmentId
	,D.DepartmentName

-- How many classes that are being taught that semester, grouped by course, and aggregating the total enrollment, total class limit, and the percentage of enrollment?
SELECT CC.CourseId
	,DC.CourseDetail
	,COUNT(CC.ClassId) AS NumberOfClasses
	,SUM(CC.NumberEnrolled) AS TotalEnrollment
	,SUM(CC.MaximumCapacity) AS TotalClassLimit
	,CAST(SUM(CC.NumberEnrolled) AS NUMERIC) / CAST(SUM(MaximumCapacity) AS NUMERIC) * 100 AS PercentageOfEnrollment
FROM [Course].[Class] AS CC
INNER JOIN [Department].[Course] AS DC ON CC.CourseId = DC.CourseId
WHERE MaximumCapacity <> 0
GROUP BY CC.CourseId
	,DC.CourseDetail

-- How many classes are held in each building, from highest to lowest?
SELECT [BuildingName]
	,COUNT(ClassId) AS NumberOfClasses
FROM [Course].[Class] AS C
INNER JOIN [Location].[Room] R ON C.RoomLocationId = R.RoomLocationId
INNER JOIN [Location].[Building] B ON R.BuildingId = B.BuildingId
GROUP BY B.BuildingId
	,[BuildingName]
ORDER BY NumberOfClasses DESC;

-- How many classes do not have an instructor assigned?
SELECT COUNT(ClassId) AS [NumberOfClasses (Without An Instructor)]
FROM Course.Class
WHERE InstructorId IS NULL;

-- How many classes are overtallied, by department, from highest to lowest?
SELECT D.DepartmentName
	,COUNT(ClassId) AS [NumberOfClasses (Overtallied)]
FROM Course.Class AS CC
INNER JOIN [Department].[Course] AS DC ON CC.CourseId = DC.CourseId
INNER JOIN [QC].[Department] AS D ON D.DepartmentId = DC.DepartmentId
WHERE NumberEnrolled > MaximumCapacity
GROUP BY DC.DepartmentId
	,D.DepartmentName
ORDER BY [NumberOfClasses (Overtallied)] DESC;