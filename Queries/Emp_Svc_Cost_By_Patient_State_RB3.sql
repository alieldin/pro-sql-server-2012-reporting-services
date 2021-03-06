USE [Pro_SSRS]
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
	WHERE ROUTINE_NAME = 'Emp_Svc_Cost_By_Patient_State_RB3'
	AND ROUTINE_SCHEMA = 'dbo')
	DROP PROCEDURE [dbo].[Emp_Svc_Cost_By_Patient_State_RB3] 
GO


CREATE PROCEDURE [dbo].[Emp_Svc_Cost_By_Patient_State_RB3]
(
	@ServiceYear INT = NULL
)
/*===========================================================================
Author:	Brian K. McDonald, MCDBA, MCSD
Purpose:
	The purpose of this script is to return a listing of Patient and Branch
	States along with Estimated Cost and Visit Count for each. This example
	will be used in Chapter 13 with Report Builder 3.0.
===========================================================================*/
AS 

CREATE TABLE #Results 
(
	PatientState CHAR(2)
	, PatientStateName VARCHAR(50)
	, BranchState CHAR(2)
	, BranchStateName VARCHAR(50)
	, [Month] VARCHAR(15)
	, MonthNumber TINYINT
	, [Year] SMALLINT
	, Visit_Count INT
	, Estimated_Cost DECIMAL(10,2)
)

---------------------------------------------------------------------------------------------------
--	2009
---------------------------------------------------------------------------------------------------
IF @ServiceYear = 2009
INSERT INTO #Results
SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, DATEADD(MONTH, -3, T.ChargeServiceStartDate)) AS [Month]
	, DATEPART(MM, DATEADD(MONTH, -3, T.ChargeServiceStartDate)) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) AS [Year]
	, CONVERT(INT, ABS((COUNT(T.ServicesTblID) * 1.5) / .75)) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), ABS((SUM(CI.Cost) * 2) / 1.5)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) = @ServiceYear 
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, DATEADD(MONTH, -3, T.ChargeServiceStartDate))
	, DATEPART(MM, DATEADD(MONTH, -3, T.ChargeServiceStartDate))
	, DATEPART(yy, T.ChargeServiceStartDate)

UNION ALL
SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, DATEADD(MONTH, -6, T.ChargeServiceStartDate)) AS [Month]
	, DATEPART(MM, DATEADD(MONTH, -6, T.ChargeServiceStartDate)) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) AS [Year]
	, COUNT(T.ServicesTblID) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), SUM(CI.Cost)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) = @ServiceYear 
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, DATEADD(MONTH, -6, T.ChargeServiceStartDate))
	, DATEPART(MM, DATEADD(MONTH, -6, T.ChargeServiceStartDate)) 
	, DATEPART(yy, T.ChargeServiceStartDate) 

UNION ALL
SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, DATEADD(MONTH, -9, T.ChargeServiceStartDate)) AS [Month]
	, DATEPART(MM, DATEADD(MONTH, -9, T.ChargeServiceStartDate)) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) AS [Year]
	, COUNT(T.ServicesTblID) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), SUM(CI.Cost)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) = @ServiceYear 
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, DATEADD(MONTH, -9, T.ChargeServiceStartDate))
	, DATEPART(MM, DATEADD(MONTH, -9, T.ChargeServiceStartDate)) 
	, DATEPART(yy, T.ChargeServiceStartDate) 

UNION ALL
SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, T.ChargeServiceStartDate) AS [Month]
	, DATEPART(MM, T.ChargeServiceStartDate) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) AS [Year]
	, COUNT(T.ServicesTblID) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), SUM(CI.Cost)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) = @ServiceYear 
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, T.ChargeServiceStartDate) 
	, DATEPART(MM, T.ChargeServiceStartDate) 
	, DATEPART(yy, T.ChargeServiceStartDate) 
ORDER BY 
	P.[State]
	, [Year]
	, [MonthNumber]

---------------------------------------------------------------------------------------------------
--	2010
---------------------------------------------------------------------------------------------------
IF @ServiceYear = 2010
INSERT INTO #Results
SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, DATEADD(MONTH, -3, T.ChargeServiceStartDate)) AS [Month]
	, DATEPART(MM, DATEADD(MONTH, -3, T.ChargeServiceStartDate)) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) + 1 AS [Year]
	, CONVERT(INT, ABS((COUNT(T.ServicesTblID)* 4) / 3.5)) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), ABS((SUM(CI.Cost) * 3) / 2)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) + 1 = @ServiceYear 
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, DATEADD(MONTH, -3, T.ChargeServiceStartDate))
	, DATEPART(MM, DATEADD(MONTH, -3, T.ChargeServiceStartDate))
	, DATEPART(yy, T.ChargeServiceStartDate) + 1

UNION ALL
SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, DATEADD(MONTH, -6, T.ChargeServiceStartDate)) AS [Month]
	, DATEPART(MM, DATEADD(MONTH, -6, T.ChargeServiceStartDate)) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) + 1 AS [Year]
	, CONVERT(INT, ABS((COUNT(T.ServicesTblID)* 4) / 3.5)) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), ABS((SUM(CI.Cost) * 3) / 2)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) + 1 = @ServiceYear 
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, DATEADD(MONTH, -6, T.ChargeServiceStartDate))
	, DATEPART(MM, DATEADD(MONTH, -6, T.ChargeServiceStartDate))
	, DATEPART(yy, T.ChargeServiceStartDate) + 1

UNION ALL
SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, DATEADD(MONTH, -9, T.ChargeServiceStartDate)) AS [Month]
	, DATEPART(MM, DATEADD(MONTH, -9, T.ChargeServiceStartDate)) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) + 1 AS [Year]
	, CONVERT(INT, ABS((COUNT(T.ServicesTblID)* 4) / 3.5)) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), ABS((SUM(CI.Cost) * 3) / 2)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) + 1 = @ServiceYear 
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, DATEADD(MONTH, -9, T.ChargeServiceStartDate))
	, DATEPART(MM, DATEADD(MONTH, -9, T.ChargeServiceStartDate))
	, DATEPART(yy, T.ChargeServiceStartDate) + 1

UNION ALL
SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, T.ChargeServiceStartDate) AS [Month]
	, DATEPART(MM, T.ChargeServiceStartDate) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) + 1 AS [Year]
	, CONVERT(INT, ABS((COUNT(T.ServicesTblID)* 4) / 3.5)) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), ABS((SUM(CI.Cost) * 3) / 2)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) + 1 = @ServiceYear 
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, T.ChargeServiceStartDate)
	, DATEPART(MM, T.ChargeServiceStartDate)
	, DATEPART(yy, T.ChargeServiceStartDate) + 1
ORDER BY 
	P.[State]
	, [Year]
	, [MonthNumber]

---------------------------------------------------------------------------------------------------
--	2011
---------------------------------------------------------------------------------------------------
IF @ServiceYear = 2011

INSERT INTO #Results
SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, DATEADD(MONTH, -3, T.ChargeServiceStartDate)) AS [Month]
	, DATEPART(MM, DATEADD(MONTH, -3, T.ChargeServiceStartDate)) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) + 2 AS [Year]
	, CONVERT(INT, ABS((COUNT(T.ServicesTblID) * 4) / 1.5)) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), ABS((SUM(CI.Cost) * 3) / 1.25)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) + 2 = @ServiceYear
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
		and st2.StateAbbr = 'KY'
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, DATEADD(MONTH, -3, T.ChargeServiceStartDate))
	, DATEPART(MM, DATEADD(MONTH, -3, T.ChargeServiceStartDate))
	, DATEPART(yy, T.ChargeServiceStartDate) + 2

UNION ALL
SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, DATEADD(MONTH, -6, T.ChargeServiceStartDate)) AS [Month]
	, DATEPART(MM, DATEADD(MONTH, -6, T.ChargeServiceStartDate)) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) + 2 AS [Year]
	, CONVERT(INT, ABS((COUNT(T.ServicesTblID) * 4) / 1.5)) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), ABS((SUM(CI.Cost) * 3) / 1.25)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) + 2 = @ServiceYear
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
		and st2.StateAbbr = 'KY'
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, DATEADD(MONTH, -6, T.ChargeServiceStartDate))
	, DATEPART(MM, DATEADD(MONTH, -6, T.ChargeServiceStartDate))
	, DATEPART(yy, T.ChargeServiceStartDate) + 2
UNION ALL

SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, DATEADD(MONTH, -9, T.ChargeServiceStartDate)) AS [Month]
	, DATEPART(MM, DATEADD(MONTH, -9, T.ChargeServiceStartDate)) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) + 2 AS [Year]
	, CONVERT(INT, ABS((COUNT(T.ServicesTblID) * 4) / 1.5)) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), ABS((SUM(CI.Cost) * 3) / 1.25)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) + 2 = @ServiceYear
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
		and st2.StateAbbr = 'KY'
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, DATEADD(MONTH, -9, T.ChargeServiceStartDate))
	, DATEPART(MM, DATEADD(MONTH, -9, T.ChargeServiceStartDate))
	, DATEPART(yy, T.ChargeServiceStartDate) + 2

UNION ALL
SELECT     
	P.[State] AS [PatientState]
	, ST.[StateName] AS [PatientStateName]
	, B.[State] AS [BranchState]
	, ST2.[StateName] AS [BranchStateName]
	, DATENAME(mm, T.ChargeServiceStartDate) AS [Month]
	, DATEPART(MM, T.ChargeServiceStartDate) AS [MonthNumber]
	, DATEPART(yy, T.ChargeServiceStartDate) + 2 AS [Year]
	, CONVERT(INT, ABS((COUNT(T.ServicesTblID) * 4) / 1.5)) AS [Visit_Count]
	, CONVERT(DECIMAL(10,2), ABS((SUM(CI.Cost) * 3) / 1.25)) AS [Estimated_Cost]
FROM
	Trx AS T
	JOIN Branch AS B ON T.Branchid = B.BranchID 
	JOIN ChargeInfo AS CI ON T.ChargeInfoID = CI.ChargeInfoID 
	JOIN Patient AS P ON T.PatID = P.PatID 
	JOIN Services AS S ON T.ServicesTblID = S.ServicesTblID 
	JOIN ServicesLogCtgry AS SLC ON S.ServicesLogCtgryID = 
	SLC.ServicesLogCtgryID 
	JOIN Employee AS E ON CI.EmployeeTblID = E.EmployeeTblID 
	JOIN Diag AS D ON CI.DiagTblID = D.DiagTblID  
	JOIN States AS ST ON P.State = ST.StateAbbr
	JOIN States AS ST2 ON B.State = ST2.StateAbbr
WHERE
	ST.StateName <> 'Guam'
	AND ((CAST(DATEPART(yy, T.ChargeServiceStartDate) AS INT) + 2 = @ServiceYear
		AND @ServiceYear IS NOT NULL)
		OR @ServiceYear IS NULL)
		and st2.StateAbbr = 'KY'
GROUP BY
	P.[State]
	, ST.[StateName]
	, B.[State]
	, ST2.[StateName]
	, DATENAME(mm, T.ChargeServiceStartDate)
	, DATEPART(MM, T.ChargeServiceStartDate)
	, DATEPART(yy, T.ChargeServiceStartDate) + 2

ORDER BY 
	P.[State]
	, [Year]
	, [MonthNumber]


SELECT 
	PatientState 
	, PatientStateName
	, BranchState
	, BranchStateName
	--, [Month]
	--, MonthNumber
	, [Year]
	, Visit_Count
	, Estimated_Cost
FROM 
	#Results


GO



EXEC [Emp_Svc_Cost_By_Patient_State_RB3] 2009
--EXEC [Emp_Svc_Cost_By_Patient_State_RB3] 2010
--EXEC [Emp_Svc_Cost_By_Patient_State_RB3] 2011
