<%@  page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title> Student Data</title>
    </head>
    <body>
        <!-- set the scripting lang to java and sql -->
        <%@ page language="java" import="java.sql.*" %>
        <%@ page language="java" import="net.FTM" %>
        <%
        int x = 0;
        String xx="not executed";
        try{
            DriverManager.registerDriver(new org.postgresql.Driver());
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345"); // Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
            Statement stmt = conn.createStatement();
            xx = "1";
            String[] table_names = {"student", "degree", "faculty", "course", "section", "research", "uCSD_Degree","teaching", "undergraduates", "graduates", "attendance", "probation", "previous_D", "weekly_Meeting", "review", "enrollment", "equivalent_num", "waitlist", "classes", "work_on_Research", "research_lead", "thesis_Committee", "advisory", "prerequirement" ,"cat_belong", "con_belong", "con_Requirement", "cat_Requirement"};
            xx = "2";
            // delete trigger
            stmt.executeUpdate("DROP TRIGGER if exists meeting_notsame_ on weekly_meeting;");
            stmt.executeUpdate("DROP TRIGGER if exists enroll_limits_ on enrollment;");
            stmt.executeUpdate("DROP TRIGGER if exists teaching_notsame_ on teaching;");
            stmt.executeUpdate("DROP TRIGGER if exists weekly_teach_notconflilct_ on weekly_meeting;");
            stmt.executeUpdate("DROP TRIGGER if exists review_conflict_ on review;");

            for(int i=table_names.length-1;i>=0;i--){ // reversed in order for dependency
                xx = "DROP TABLE IF EXISTS "+table_names[i]+";";
                stmt.executeUpdate("DROP TABLE IF EXISTS "+table_names[i]+" CASCADE;");
            }
            //drop materialized views/triggers/trigger functions
            stmt.executeUpdate("DROP TABLE IF EXISTS CPQG");
            stmt.executeUpdate("DROP TABLE IF EXISTS CPG");
            stmt.executeUpdate("DROP TRIGGER IF EXISTS insert_trigger ON enrollment");
            stmt.executeUpdate("DROP TRIGGER IF EXISTS update_trigger ON enrollment");
            stmt.executeUpdate("DROP TRIGGER IF EXISTS delete_trigger ON enrollment");
            stmt.executeUpdate("DROP FUNCTION IF EXISTS insert_to_materialized_view");
            stmt.executeUpdate("DROP FUNCTION IF EXISTS update_to_materialized_view");
            stmt.executeUpdate("DROP FUNCTION IF EXISTS delete_to_materialized_view");
            //drop conversion grade tables
            stmt.executeUpdate("DROP TABLE IF EXISTS grade_conversion");
            xx = "success";
            conn.close();
        }catch(Exception e){
            e.printStackTrace();
            xx = "fail___"+xx;
            x = 0;
        }
        %>


            <span> result is <%= xx %> </span>


    </body>
</html>
