<%@  page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title> Display Data</title>
        <style>
            table {
                border-collapse: collapse;
                width: 100%;
            }
            th,td{
                border: 1px solid black;
                padding: 8px;
                text-align: left;
            }
            th{
                background-color: #f2f2f2;
            }
        </style>
    </head>
    <body>
        <!-- set the scripting lang to java and sql -->
        <%@ page language="java" import="java.sql.*" %>
        <%@ page language="java" import="java.util.*" %>
        <%-- create a table to display data --%>
        <table>
            <tbody>
    <%
        int x = 0;
        try{
            //connect to database driver
            DriverManager.registerDriver(new org.postgresql.Driver());
            // ******* different for each other *****
            Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
            //System.out.println("connected");

            //Detect which request it is:
            String tName = request.getParameter("request");
            //Hash Table for grade calculation
                HashMap<String, Double> convert = new HashMap<String,Double>();
                convert.put("A PLUS", 4.3);
                convert.put("A", 4.0);
                convert.put("A-", 3.7);
                convert.put("B PLUS", 3.4);
                convert.put("B", 3.1);
                convert.put("B-", 2.8);
                convert.put("C PLUS", 2.5);
                convert.put("C", 2.2);
                convert.put("C-", 1.9);
                convert.put("D", 1.6);
            /***** r1 ******/
            if(tName.equals("r1")){
                String s_snn = request.getParameter("snn");
                String r1_Query = "SELECT x.*, z.c_number, z.section_id, z.quarter, z.s_year, z.title, y.option, y.units, k.enroll_limit, k.mandatory"+ 
                " FROM student x, enrollment y, classes z, section k" + 
                " WHERE x.social_security_num = '"+s_snn+"' AND "+ 
                "y.student_id = x.student_id  AND "+
                "y.s_year = 2023 AND z.s_year = 2023 AND "+ 
                "z.quarter = 'Spring' AND "+ 
                "y.section_id = z.section_id AND "+
                "k.section_id = y.section_id ";

                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(r1_Query);
                boolean head = false;
                HashSet<String> course_hs = new HashSet<>();
                while(rs.next()){ 
                    if(!head){
    %>
                        <tr>
                            <td>Student id:</td>
                            <td>First Name:</td>
                            <td>Last Name:</td>
                            <td>Middle Name:</td>
                            <td>SNN:</td>
                            <td>Enrolled?:</td>
                            <td>CA Residence:</td>
                            <td>Major:</td>
                            <td>Minor:</td>
                        </tr>
                        <tr>
                            <td> <%= rs.getString(1) %> </td>
                            <td> <%= rs.getString(2) %> </td>
                            <td> <%= rs.getString(3) %> </td>
                            <td> <%= rs.getString(4) %> </td>
                            <td> <%= rs.getString(5) %> </td>
                            <td> <%= rs.getString(6) %> </td>
                            <td> <%= rs.getString(7) %> </td>
                            <td> <%= rs.getString(8) %> </td>
                            <td> <%= rs.getString(9) %> </td>
                        </tr>
                        <tr>
                            <td>Course:</td>
                            <td>Section #:</td>
                            <td>Quarter:</td>
                            <td>Year:</td>
                            <td>Class Title:</td>
                            <td>Grade Option:</td>
                            <td># units:</td>
                            <td>Enrollement Limit:</td>
                            <td>Discussion Mandatory?:</td>
                        </tr> 
        <%
                        head = true;
                    }
                    if(!course_hs.contains(rs.getString(10))){
                        course_hs.add(rs.getString(10));
        %>

                        <tr>
                            <td><%= rs.getString(10) %> </td>
                            <td><%= rs.getString(11) %> </td>
                            <td><%= rs.getString(12) %></td>
                            <td><%= rs.getString(13) %> </td>
                            <td><%= rs.getString(14) %> </td>
                            <td><%= rs.getString(15) %> </td>
                            <td><%= rs.getString(16) %> </td>
                            <td><%= rs.getString(17) %> </td>
                            <td><%= rs.getString(18) %> </td>
                        </tr>                   
        <%
                    }
                }
            /***** r2 *****/
            }else if(tName.equals("r2")){
                String[] c = request.getParameter("class").split(" ");
                String r2_Query = "SELECT * "+
                                    "FROM (SELECT x.c_number "+
                                    "FROM course x, classes y "+
                                    "WHERE y.title = '"+c[0]+"' AND "+
                                    "y.quarter = '"+c[1]+"' AND " +
                                    "y.s_year = '"+c[2]+"' AND "+
                                    "x.c_number = y.c_number) t1 LEFT JOIN (SELECT y.*, j.*, z.option, z.units "+
                                    "FROM course x, classes y, enrollment z, student j "+
                                    "WHERE y.title = '"+c[0]+"' AND "+
                                    "y.quarter = '"+c[1]+"' AND "+
                                    "y.s_year = '"+c[2]+"' AND "+
                                    "x.c_number = y.c_number AND "+
                                    "z.c_number = x.c_number AND "+
                                    "z.s_year = y.s_year AND "+
                                    "z.section_id = y.section_id AND "+
                                    "z.student_id = j.student_id) t2 ON t1.c_number = t2.c_number ";

                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(r2_Query);
        %>
                    <h1>Class:</h1>
                        <tr>
                            <td> Title: </td>
                            <td> Quarter: </td>
                            <td> Year: </td>
                        </tr>
                        <tr>
                            <td> <%=c[0]%> </td>
                            <td> <%=c[1]%> </td>
                            <td> <%=c[2]%> </td>  
                        </tr>
                        <tr>
                            <td>---------Courses----------</td>
                        </tr>
        <%
                String prev = "";
                while(rs.next()){
                    if(!rs.getString(1).equals(prev)){
                        //display course
        %>
                        <tr>
                            <td>Course #:</td>
                            <td>Quarter:</td>
                            <td>Year:</td>
                        </tr>
                        <tr>
                            <td><%= rs.getString(1)%></td>
                            <td><%= c[1]%></td>
                            <td><%= c[2]%></td>
                        </tr>
                        <tr>
                            <td>---------Student Roster----------</td>
                        </tr>
                        <tr>
                            <td>Student id:</td>
                            <td>First Name:</td>
                            <td>Last Name:</td>
                            <td>Middle Name:</td>
                            <td>SNN:</td>
                            <td>Enrolled?:</td>
                            <td>CA:</td>
                            <td>Major:</td>
                            <td>Minor:</td>
                            <td>Grade Option:</td>
                            <td># of Units:</td>
                        </tr>
        <%
                        prev = rs.getString(1);
                    }
                    if(rs.getString(2) != null){
        %>
                        <tr>
                            <td> <%= rs.getString(7) %> </td>
                            <td> <%= rs.getString(8) %> </td>
                            <td> <%= rs.getString(9) %> </td>
                            <td> <%= rs.getString(10) %> </td>
                            <td> <%= rs.getString(11) %> </td>
                            <td> <%= rs.getString(12) %> </td>
                            <td> <%= rs.getString(13) %> </td>
                            <td> <%= rs.getString(14) %> </td>
                            <td> <%= rs.getString(15) %> </td>
                            <td> <%= rs.getString(16) %> </td>
                            <td> <%= rs.getString(17) %> </td>
                        </tr>
        <%
                    }
        %>
                    <tr><td></td></tr>
        <%
                }
            /***** r3 *****/
            }else if(tName.equals("r3")){
                String snn = request.getParameter("snn");
                String r3_Query = "SELECT * FROM student WHERE social_security_num = " + snn;
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(r3_Query);
                
                //create table for student info
                while(rs.next()){
        %>
                    <tr>
                        <td>Student id:</td>
                        <td>First Name:</td>
                        <td>Last Name:</td>
                        <td>Middle Name:</td>
                        <td>SNN:</td>
                        <td>Enrolled?:</td>
                        <td>CA Residence:</td>
                        <td>Major:</td>
                        <td>Minor:</td>
                    </tr>
                    <tr>
                        <td> <%= rs.getString(1) %> </td>
                        <td> <%= rs.getString(2) %> </td>
                        <td> <%= rs.getString(3) %> </td>
                        <td> <%= rs.getString(4) %> </td>
                        <td> <%= rs.getString(5) %> </td>
                        <td> <%= rs.getString(6) %> </td>
                        <td> <%= rs.getString(7) %> </td>
                        <td> <%= rs.getString(8) %> </td>
                        <td> <%= rs.getString(9) %> </td>
                    </tr>
                    <tr><td></td></tr>
        <%
                }
                r3_Query = "SELECT y.*, z.units, z.grade "+
                            "FROM student x, classes y, enrollment z "+
                            "WHERE x.social_security_num = " + snn + " AND "+
                            "x.student_id = z.student_id AND "+
                            "z.c_number = y.c_number AND "+
                            "z.section_id = y.section_id "+
                            "ORDER BY (y.quarter, y.s_year)";
                stmt = connection.createStatement();
                rs = stmt.executeQuery(r3_Query);
                String prev = "";
                double q_gpa = 0;
                double cum_GPA = 0;
                int q_total = 0;
                int total = 0;
                boolean first = false;
                while(rs.next()){
                    if(!(rs.getString(3) + rs.getString(4)).equals(prev)){
                        //create course title
                        if(first){
        %>
                            <tr>
                                <td>Term GPA: <%= q_gpa/q_total %></td>
                            </tr>
                            <tr><td></td></tr>
        <%
                            //reset for next quarter 
                            q_gpa = 0;
                            q_total = 0;
                        }
        %>
                        <tr>
                            <td>Term: <%= rs.getString(3) + " " + rs.getString(4) %></td>
                        </tr>
                        <tr>
                            <td>Course #:</td>
                            <td>Title</td>
                            <td>Section #:</td>
                            <td>Quarter:</td>
                            <td>Year:</td>
                            <td>Units:</td>
                            <td>Grade:</td>
                        </tr>
        <%
                        first = true;
                        prev = rs.getString(3) + rs.getString(4);
                    }
                    //display course
        %>
                    <tr>
                        <td><%= rs.getString(1)%></td>
                        <td><%= rs.getString(5)%></td>
                        <td><%= rs.getString(2)%></td>
                        <td><%=rs.getString(3) %></td>
                        <td><%=rs.getString(4) %></td>
                        <td><%= rs.getString(6)%></td>
                        <td><%= rs.getString(7)%></td>
                    </tr>
        <%          
                    if(!rs.getString(7).equals("IN") && !rs.getString(7).equals("S") && !rs.getString(7).equals("U")){
                        q_gpa+= convert.get(rs.getString(7));
                        cum_GPA+=convert.get(rs.getString(7));
                        q_total+=1;
                        total+=1;
                    }
                }
                //calculate cum and quarter gpa
        %>
                <tr>
                    <td>Term GPA: <%= q_gpa/q_total %></td>
                </tr>
                <tr>
                    <td>Cummulative GPA: <%= cum_GPA/total %></td>
                </tr>
        <%

            /***** r4 *****/
            }else if(tName.equals("r4")){
                String snn = request.getParameter("snn");
                String[] degree = request.getParameter("ucsd_degree").replace("in ", "").replace("from department: ", "").split(" ");
                String r4_Query = "SELECT * FROM student WHERE social_security_num = " + snn;
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(r4_Query);

                String student_id = "";
                int t_units = 0;
                //display student
                while(rs.next()){
                    student_id = rs.getString(1);
        %>
                    <tr>
                        <td>Student id:</td>
                        <td>First Name:</td>
                        <td>Last Name:</td>
                        <td>Middle Name:</td>
                        <td>SNN:</td>
                        <td>Enrolled?:</td>
                        <td>CA Residence:</td>
                        <td>Major:</td>
                        <td>Minor:</td>
                    </tr>
                    <tr>
                        <td> <%= rs.getString(1) %> </td>
                        <td> <%= rs.getString(2) %> </td>
                        <td> <%= rs.getString(3) %> </td>
                        <td> <%= rs.getString(4) %> </td>
                        <td> <%= rs.getString(5) %> </td>
                        <td> <%= rs.getString(6) %> </td>
                        <td> <%= rs.getString(7) %> </td>
                        <td> <%= rs.getString(8) %> </td>
                        <td> <%= rs.getString(9) %> </td>
                    </tr>
                    <tr><td></td></tr>
        <%
                }
                r4_Query = "SELECT * FROM enrollment WHERE student_id = '"+student_id+"'";
                stmt = connection.createStatement();
                rs = stmt.executeQuery(r4_Query);
                HashMap<String, Integer> enroll_hm = new HashMap<>();
                //collect all classes students have took
                while(rs.next()){
                    if(!enroll_hm.containsKey(rs.getString(2))){
                        enroll_hm.put(rs.getString(2), Integer.valueOf(rs.getString(6)));
                    }
                    t_units+= Integer.valueOf(rs.getString(6));
                }

                r4_Query = "SELECT * FROM ucsd_degree WHERE department = '"+degree[2]+"' AND major = '"+degree[1]+"' AND level = '"+degree[0]+"'";
                stmt = connection.createStatement();
                rs = stmt.executeQuery(r4_Query);
                //display degree units left for student to satisfy
                while(rs.next()){
        %>
                    <tr>
                        <td>Degree:</td>
                        <td>Major:</td>
                        <td>Require Total Units:</td>
                        <td> Units acquired: </td>
                        <td> Units lefted to obtain:</td>
                    </tr>
                    <tr>
                        <td> <%= rs.getString(3) %> </td>
                        <td> <%= rs.getString(2) %> </td>
                        <td> <%= rs.getString(4) %> </td>
                        <td> <%= t_units %> </td>
                        <td> <%= Math.max(0,Integer.valueOf(rs.getString(4)) - t_units)%> </td>
                    </tr>
        <%
                }

                HashMap<String,Integer> cat_hm2 = new HashMap<>();
                r4_Query = "SELECT y.c_name, x.c_number FROM enrollment x, cat_belong y WHERE x.student_id = '"+student_id+"' AND x.c_number = y.c_number ";
                stmt = connection.createStatement();
                rs = stmt.executeQuery(r4_Query);
                while(rs.next()){
                    String cat = rs.getString(1);
                    String course = rs.getString(2);
                    if(!cat_hm2.containsKey(cat)){
                        cat_hm2.put(cat,enroll_hm.get(course));
                    }else{
                        cat_hm2.put(cat,cat_hm2.get(cat) + enroll_hm.get(course));
                    }
                }

                r4_Query = "SELECT * FROM cat_requirement WHERE department = '"+degree[2]+"' AND major = '"+degree[1]+"' AND level = '"+degree[0]+"'";
                stmt = connection.createStatement();
                rs = stmt.executeQuery(r4_Query);
        %>
                <tr><td></td></tr>
                <tr>
                    <td>Category Name:</td>
                    <td>Minimum Units Required:</td>
                    <td> Units acquired: </td>
                    <td> Units lefted to obtain:</td>
                </tr>
        <%
                while(rs.next()){
        %>
                    <tr>
                        <td> <%= rs.getString(1) %> </td>
                        <td> <%= rs.getString(5) %> </td>

        <%
                    if(!cat_hm2.containsKey(rs.getString(1))){
        %>  
                        <td> 0 </td>
                        <td> <%= Integer.valueOf(rs.getString(5)) %> </td>
                    </tr>
        <%
                    }else{
        %>  
                        <td> <%= cat_hm2.get(rs.getString(1)) %> </td>
                        <td> <%= Math.max(0,Integer.valueOf(rs.getString(5)) - cat_hm2.get(rs.getString(1))) %> </td>
                    </tr>
        <%
                    }
                }

                //get all of the student's courses they have ever took
                //count of total units of the student
                //store all categories of degree
                //align courses with these categories and total them up

            /***** r5 *****/
            }else if(tName.equals("r5")){
                String snn = request.getParameter("snn");
                String[] degree = request.getParameter("ucsd_degree").replace("in ", "").replace("from department: ", "").split(" ");
                String r5_Query = "SELECT * FROM student WHERE social_security_num = " + snn;
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(r5_Query);

                String student_id = "";
                //display student
                while(rs.next()){
                    student_id = rs.getString(1);
        %>
                    <tr>
                        <td>Student id:</td>
                        <td>First Name:</td>
                        <td>Last Name:</td>
                        <td>Middle Name:</td>
                        <td>SNN:</td>
                        <td>Enrolled?:</td>
                        <td>CA Residence:</td>
                        <td>Major:</td>
                        <td>Minor:</td>
                    </tr>
                    <tr>
                        <td> <%= rs.getString(1) %> </td>
                        <td> <%= rs.getString(2) %> </td>
                        <td> <%= rs.getString(3) %> </td>
                        <td> <%= rs.getString(4) %> </td>
                        <td> <%= rs.getString(5) %> </td>
                        <td> <%= rs.getString(6) %> </td>
                        <td> <%= rs.getString(7) %> </td>
                        <td> <%= rs.getString(8) %> </td>
                        <td> <%= rs.getString(9) %> </td>
                    </tr>
                    <tr><td></td></tr>
        <%
                }
                //Display the name of all concentration that student has completed where units/gpa is good
                r5_Query = "CREATE TEMP VIEW temp_con AS("+
                            "SELECT z.con_name, z.min_gpa, z.min_units "+
                            "FROM con_requirement z "+
                            "WHERE z.department = '"+degree[2]+"' AND "+
                                        "z.major = '"+degree[1]+"' AND "+
                                        "z.level = '"+degree[0]+"')";

                stmt = connection.createStatement();
                stmt.executeUpdate(r5_Query);
        %>
                <tr><td>Completed Concentration Names:</td></tr>
        <%

                r5_Query = "SELECT z.con_name, z.min_gpa,z.min_units, x.c_number,y.units, y.grade "+
                            "FROM con_belong x, enrollment y, temp_con z "+
                            "where y.student_id = '"+student_id+"' AND "+
                                    "x.con_name = z.con_name AND "+
                                    "x.c_number = y.c_number ORDER BY(z.con_name)";
                stmt = connection.createStatement();
                rs = stmt.executeQuery(r5_Query);
                String prev = "";
                double min_gpa = 0.0;
                double gpa = 0.0;
                int count = 0;
                int c_units = 0;
                int t_units = 0;
                while(rs.next()){
                    if(!rs.getString(1).equals(prev) && !prev.equals("")){
                        if(Integer.valueOf(rs.getString(3)) <= c_units && (gpa/count) >= Double.valueOf(rs.getString(2))){
        %>
                            <tr>
                                <td><%=prev%></td>
                            </tr>
        <%
                        }
                        //reset
                        gpa = 0.0;
                        count = 0;
                        c_units = 0;
                    }
                    //calculate gpa
                    if(!rs.getString(6).equals("IN") && !rs.getString(6).equals("S") && !rs.getString(6).equals("U")){
                        count+=1;
                        gpa+= convert.get(rs.getString(6));
                    }
                    if(!rs.getString(6).equals("IN")){
                        c_units+= Integer.valueOf(rs.getString(5));
                    }
                    prev = rs.getString(1);
                    t_units = Integer.valueOf(rs.getString(3));
                    min_gpa = Double.valueOf(rs.getString(2));
                }
            if(t_units <= c_units && (gpa/count) >= min_gpa){
        %>
                <tr>
                    <td><%=prev%></td>
                </tr>
                <tr><td></td></tr>
        <%
            }  

            //create view
            r5_Query = "CREATE TEMP VIEW temp_course AS( "+
                                        "SELECT DISTINCT z.con_name, x.c_number "+
                                        "FROM con_belong x, enrollment y, temp_con z "+
                                        "where (y.student_id = '"+student_id+"' AND "+
                                            "x.con_name = z.con_name AND "+
                                            "x.c_number = y.c_number AND "+
                                            "y.grade = 'IN') OR x.c_number NOT IN (SELECT c_number from enrollment WHERE student_id = '"+student_id+"') "+
                                            "ORDER BY(z.con_name))";
            stmt = connection.createStatement();
            stmt.executeUpdate(r5_Query);

            //Query run first
            r5_Query = "SELECT r2.con_name, r2.c_number, r1.quarter, r1.s_year "+
                        "FROM (SELECT DISTINCT x.c_number, y.quarter, y.s_year "+
                                "FROM temp_course x, classes y "+
                                "WHERE(y.s_year = 2023 AND quarter = 'SummerI') OR (y.s_year = 2023 AND quarter = 'SummerII') OR (y.s_year > 2023)) r1 JOIN (SELECT * FROM temp_course) r2 ON r1.c_number = r2.c_number ORDER BY(r2.con_name,r2.c_number)";
            stmt = connection.createStatement();
            rs = stmt.executeQuery(r5_Query);
        %>
            <tr><td>Courses student has not taken yet:</td></tr>
        <%
            HashMap<String, String> course_hm = new HashMap<>();
            while(rs.next()){
                if(!course_hm.containsKey(rs.getString(2))){
                    course_hm.put(rs.getString(2),rs.getString(3) +" "+ rs.getString(4));
                }else{
                    String[] old_q_y = course_hm.get(rs.getString(2)).split(" ");
                    if(Integer.valueOf (rs.getString(4)) < Integer.valueOf(old_q_y[1])){
                        course_hm.put(rs.getString(2),rs.getString(3) +" "+ rs.getString(4));
                    }else if(Integer.valueOf(rs.getString(4)) == Integer.valueOf(old_q_y[1])){
                        if(rs.getString(3).equals("SummerI")){
                            course_hm.put(rs.getString(2),rs.getString(3) +" "+ rs.getString(4));
                        }else if(rs.getString(3).equals("SummerII")){
                            course_hm.put(rs.getString(2),rs.getString(3) +" "+ rs.getString(4));
                        }else if(rs.getString(3).equals("Fall")){
                            course_hm.put(rs.getString(2),rs.getString(3) +" "+ rs.getString(4));
                        }else if(rs.getString(3).equals("Winter")){
                            course_hm.put(rs.getString(2),rs.getString(3) +" "+ rs.getString(4));
                        }
                    }
                }
            }
            //Query run 2
            r5_Query = "SELECT r2.con_name, r2.c_number, r1.quarter, r1.s_year "+
                        "FROM (SELECT DISTINCT x.c_number, y.quarter, y.s_year "+
                                "FROM temp_course x, classes y "+
                                "WHERE(y.s_year = 2023 AND quarter = 'SummerI') OR (y.s_year = 2023 AND quarter = 'SummerII') OR (y.s_year > 2023)) r1 JOIN (SELECT * FROM temp_course) r2 ON r1.c_number = r2.c_number ORDER BY(r2.con_name,r2.c_number)";
            stmt = connection.createStatement();
            rs = stmt.executeQuery(r5_Query);
            prev = "";
            String prev_course = "";

            while(rs.next()){

                if(!rs.getString(1).equals(prev)){
        %>
                    <tr>
                        <td>Concentration Name: <%= rs.getString(1) %></td>
                    </tr>          
        <%
                    prev_course = "";
                }
                if(!rs.getString(2).equals(prev_course)){
        %>
                    <tr>
                        <td>Course:<%= rs.getString(2) %></td>
                        <td>Earliest time course is offered: <%=course_hm.get(rs.getString(2)) %></td>
                    </tr>          
        <%
                }

                prev_course = rs.getString(2);
                prev = rs.getString(1);
            }


            }else if(tName.equals("r8")){
                String course = request.getParameter("c_number");
                String f_name = request.getParameter("name");
                String time = request.getParameter("time");
                String[] t = request.getParameter("time").split(" ");
                String r8_Query = "";
                Statement stmt = connection.createStatement();
                if(time.equals("Select a time") && f_name.equals("Select a professor")){
                    r8_Query = "SELECT DISTINCT grade,count(grade) FROM enrollment WHERE c_number = '"+course+"' GROUP BY (grade)";
                    stmt = connection.createStatement();
                    ResultSet rs = stmt.executeQuery(r8_Query);
        %>
                    <tr><td>course: <%= course %></td></tr>
                    <tr><td></td></tr>
                    <tr><td>Course Grade Stats over the years</td></tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>Grades</td>
                        <td>Grade total #</td>
                    </tr>
        <%
                    while(rs.next()){
        %>
                        <tr>
                            <td><%=rs.getString(1).replace(" PLUS", "+")%></td>
                            <td><%=rs.getString(2)%></td>
                        </tr>
        <%
                    }
                }else if(time.equals("Select a time")){
                    /* OLD tables
                    r8_Query = "SELECT grade, count, number_grade "+
                                "FROM (SELECT DISTINCT grade,count(grade) AS count "+
                                        "FROM teaching x, enrollment y "+
                                            "WHERE x.f_name = '"+f_name+"' AND "+
                                                "y.section_id = x.section_id AND "+
                                                "y.s_year = x.s_year AND "+
                                                "y.c_number = '"+course+"' "+
                                                "GROUP BY (grade)) r1 NATURAL JOIN grade_conversion r2 "+
                                "WHERE r1.grade = r2.letter_grade";
                    */
                    //CPG
                    r8_Query = "SELECT DISTINCT grade, count, number_grade "+
                                "FROM (SELECT grade, count FROM CPG WHERE c_number = '"+course+"' AND f_name = '"+f_name+"') r1 NATURAL JOIN grade_conversion r2 "+
                                "WHERE r1.grade = r2.letter_grade;";
                    stmt = connection.createStatement();
                    ResultSet rs = stmt.executeQuery(r8_Query);
        %>
                    <tr><td><%=course%> taught by: <%=f_name%></td></tr>
                    <tr><td></td></tr>
                    <tr><td>Course Grade Stats over the years</td></tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>Grades</td>
                        <td>Grade total #</td>
                    </tr>
        <%
                    double gpa = 0.0;
                    int total = 0;
                    while(rs.next()){
        %>
                        <tr>
                            <td><%=rs.getString(1).replace(" PLUS", "+")%></td>
                            <td><%=rs.getString(2)%></td>
                        </tr>
        <%
                        if(!rs.getString(1).equals("IN") && !rs.getString(1).equals("S") && !rs.getString(1).equals("U")){
                            gpa+= Integer.valueOf(rs.getString(2)) * Double.valueOf(rs.getString(3));
                            total+= Integer.valueOf(rs.getString(2));
                        }
                    }
        %>
                    <tr>
                        <td>Professor <%=f_name +"'s"%> gpa on course <%=course%> is: <%=gpa/total%></td>
                    </tr>
        <%
                }else{
                    /*
                    r8_Query = "SELECT DISTINCT grade,count(grade) AS count "+
                                "FROM teaching x, enrollment y, classes z "+
                                    "WHERE x.f_name = '"+f_name+"' AND "+
                                        "y.section_id = x.section_id AND "+
                                        "y.s_year = x.s_year AND "+
                                        "y.c_number = '"+course+"' AND "+
                                        "x.section_id = z.section_id AND "+
                                        "x.s_year = z.s_year AND "+
                                        "y.c_number = z.c_number AND "+
                                        "z.quarter = '"+t[0]+"' AND "+
                                        "z.s_year = "+t[1]+" "+
                                        "GROUP BY (grade)";
                    */
                    //CPQG
                    r8_Query = "SELECT grade, count "+
                                "FROM CPQG "+
                                "WHERE c_number = '"+course+"' AND f_name = '"+f_name+"' AND quarter = '"+t[0]+"' AND s_year = "+t[1]+";";
                    stmt = connection.createStatement();
                    ResultSet rs = stmt.executeQuery(r8_Query);
        %>
                    <tr><td>course: <%=course%></td></tr>
                    <tr><td></td></tr>
                    <tr><td>Course Grade Stats over the quarter: <%=t[0] 
                    + " " + t[1]%></td></tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>Grades</td>
                        <td>Grade total #</td>
                    </tr>
        <%
                    while(rs.next()){
        %>
                        <tr>
                            <td><%=rs.getString(1).replace(" PLUS", "+")%></td>
                            <td><%=rs.getString(2)%></td>
                        </tr>
        <%
                    }
                }

            }else{
        %>
                <tr>
                    <td>  Fail </td>
                </tr>  
        <%
            }
            connection.close();
        }catch(Exception e){
            e.printStackTrace();
            // String xx = "fail";
            x = 0;
        }
        %>

            </tbody>
        </table>

    </body>
</html>

