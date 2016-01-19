USE msdb
EXEC sp_send_dbmail
      @profile_name = 'MKTX Mail',
      @recipients = 'SecurityNotifications@email.com',
      @subject = 'Software installed on the prior day',
     -- @body_format = 'HTML',
	  @body = 'Software installed on the prior day',
      @execute_query_database = 'CM_PRI',
      @query = '
SELECT
        dbo.v_R_System.Name0 AS [Computer Name],
        dbo.v_GS_INSTALLED_SOFTWARE.ARPDisplayName0 AS [Software Name],
        -- dbo.v_GS_INSTALLED_SOFTWARE.InstallDate0,
        DATEDIFF(Day, CONVERT(date,dbo.v_GS_INSTALLED_SOFTWARE.InstallDate0), GETDATE()) AS [Days Since Installed]

FROM
        dbo.v_R_System INNER JOIN
        dbo.v_GS_INSTALLED_SOFTWARE ON
        dbo.v_R_System.ResourceID = dbo.v_GS_INSTALLED_SOFTWARE.ResourceID
        
WHERE
        (SELECT ISDATE(dbo.v_GS_INSTALLED_SOFTWARE.InstallDate0)) = 1

GROUP BY 
        dbo.v_R_System.Name0,
        dbo.v_GS_INSTALLED_SOFTWARE.ARPDisplayName0,
        dbo.v_GS_INSTALLED_SOFTWARE.InstallDate0,
        DATEDIFF(Day, CONVERT(date,dbo.v_GS_INSTALLED_SOFTWARE.InstallDate0), GETDATE())

HAVING
        (
        (CASE WHEN (ISDATE(dbo.v_GS_INSTALLED_SOFTWARE.InstallDate0))=1 THEN
                (DATEDIFF(Day, CONVERT(date,dbo.v_GS_INSTALLED_SOFTWARE.InstallDate0), GETDATE()))
        ELSE    500
        END) > 0 AND 
        (CASE WHEN (ISDATE(dbo.v_GS_INSTALLED_SOFTWARE.InstallDate0))=1 THEN
                (DATEDIFF(Day, CONVERT(date,dbo.v_GS_INSTALLED_SOFTWARE.InstallDate0), GETDATE()))
        ELSE    500
        END) <= 1
        )
ORDER BY dbo.v_R_System.Name0        

        '
