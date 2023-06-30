

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
        <%
        int x = 0;
        String id = "";
        try{
            DriverManager.registerDriver(new org.postgresql.Driver());
            // ******* different for each other *****
            Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
            // String xx = "connected";
            x = 1;
            //System.out.println("connected");
            String student_Query = "Select * from student";
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(student_Query);
            while(rs.next()){ 
                id = rs.getString(1);
            }
            connection.close();
        }catch(Exception e){
            e.printStackTrace();
            // String xx = "fail";
            x = 0;
        }
        %>

            <span> student id is: <%= id %> </span>


    </body>
</html>
