<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html>

  <head>
    <meta charset="UTF-8">
    <title> Student Data</title>

    <link rel="stylesheet" type="text/css" href="styles.css">
    <script src="render.js"></script>
  </head>

  <%@ page language="java" import="javax.servlet.jsp.JspWriter " %>
  <%@ page language="java" import="java.util.* " %>
  <%!


    public String sql_js(String[][] myArray, String table_name, String formtype){
      // convert sql 2d string to js 2d string
        String jsArray = "<script> var "+table_name+" =[";
        for (int i = 0; i < myArray.length; i++) {
          jsArray += "[";
          for (int j = 0; j < myArray[i].length; j++) {
            jsArray += "'" + myArray[i][j] + "'";
            if (j < myArray[i].length - 1) {
              jsArray += ",";
            }
          }
          jsArray += "]";
          if (i < myArray.length - 1) {
            jsArray += ",";
          }
        }
        jsArray += "]; ";
        // automatically show it
        // jsArray += "data_entity("+table_name+",\""+table_name+"\");";
        jsArray += formtype + "("+table_name+",\""+table_name+"\");";
        jsArray += "</script>";
        return jsArray;
    }

    public void item_menu_post(String[] item, JspWriter myout){
      // this is by post
      try{

        //<form action = "FTMweb.jsp" method = "POST">
         //<input class="menu_item" type = "submit" value = "Student" />
      //</form>
        String html = "";
        for(int i=0;i<item.length;i++){
          html += "<form action = \"FTMweb.jsp\" method = \"POST\"> \n";
          html += "<input class=\"menu_item\" type = \"submit\" value = \""+item[i]+"\"  name=\"table_name\" /> \n";
          html += "</form>\n";
        }
        // write
        myout.println(html);
      }
      catch(Exception eek) { }
    }

    public void item_menu_get(String[] table_name, String[] item, JspWriter myout){
      // this is by get
      try{

        //<form action = "FTMweb.jsp" method = "POST">
         //<input class="menu_item" type = "submit" value = "Student" />
      //</form>
        String html = "";
        for(int i=0;i<item.length;i++){
          html += "<a href=\"?type=general&"+"table_name="+table_name[i] +"\"" + ">"+item[i]+"</a>\n";
        }
        // write
        myout.println(html);
      }
      catch(Exception eek) { }
    }

    // initializeation
    public static Connection initial_sql(JspWriter myout){ // can't directly use out in function
         return null;
      }
  %>

  <%
    // for initialization
    // why this can be written in funciton ??
    Connection conn=null;
    Statement stmt = null;
    try{
        DriverManager.registerDriver(new org.postgresql.Driver());
        conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
        //System.out.println("connected");
        stmt = conn.createStatement();
        // connection.close(); // move to the end
    }catch(Exception e){
        // xx = "fail";
        out.println("fail to connect to database");
        // myout.println();
        e.printStackTrace();
    }
  %>

  <%
  /**r1**/
         String r1_Query = "SELECT z.social_security_num, z.first_name, z.middle_name, z.last_name " +
                           "FROM enrollment x, classes y, student z "+
                           "WHERE x.c_number = y.c_number AND "+
                           "x.s_year = y.s_year AND "+
                           "y.quarter = 'Spring' AND "+
                           "z.student_id = x.student_id ";
        ResultSet rs = stmt.executeQuery(r1_Query);
    %>
        <script>var r1 = [];</script>
        <script> var r1_n = [];</script>
    <%
        Set<String> hs = new HashSet<>();
        Set<String> hs2 = new HashSet<>();
        while(rs.next()){
          hs.add(rs.getString(1));
          hs2.add(": " + rs.getString(2) +" "+ rs.getString(3) + " "+ rs.getString(4));
        }
        for(String x: hs){
          %>
            <script>
              r1.push("<%= x %>");
            </script>
          <%

        }
        for(String x: hs2){
          %>
            <script>
              r1_n.push("<%= x %>");
            </script>
          <%

        }
        /**r2**/
        String r2_Query = "SELECT title, quarter, s_year FROM classes";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(r2_Query);
    %>
        <script>var r2 = [];</script>
    <%
        hs.clear();
        while(rs.next()){
          hs.add("Title:" + rs.getString(1) + " Quarter:" + rs.getString(2) + " Year:" + rs.getString(3));
        }
        for(String x: hs){
          %>
            <script>
              r2.push("<%= x %>");
            </script>
          <%
        }
        /**r3**/
        String r3_Query = "SELECT * FROM student x WHERE x.student_id in (SELECT y.student_id FROM attendance y)";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(r3_Query);
    %>
        <script>var r3 = [];</script>
        <script>var r3_n= [];</script>
    <%
        while(rs.next()){
          %>
            <script>
              r3.push("<%= rs.getString(5) %>");
              r3_n.push("<%= ": " + rs.getString(2) + " " +rs.getString(4) + " " +rs.getString(3) %>");
            </script>
          <%
        }
        /**r4**/
        String r4_Query = "SELECT k.social_security_num "+
                          "FROM undergraduates x, student k "+
                          "WHERE x.student_id = k.student_id AND x.student_id IN (SELECT y.student_id "+
                                                                                  "FROM enrollment y, classes z "+
                                                                                  "WHERE y.c_number = z.c_number AND "+
                                                                                  "y.section_id = z.section_id AND "+
                                                                                    "z.quarter = 'Spring' AND "+
                                                                                  "z.s_year = 2023)";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(r4_Query);
    %>
        <script>var r4 = [];</script>
    <%

        while(rs.next()){
        %>
          <script>
            r4.push("<%= rs.getString(1) %>");
          </script>
        <%
        }
        r4_Query = "SELECT * FROM ucsd_degree WHERE level = 'BS'";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(r4_Query);
    %>
        <script>var r4_d = [];</script>
    <%
        while(rs.next()){
    %>
            <script>
              r4_d.push("<%= rs.getString(3) + " in " + rs.getString(2) + " from department: " + rs.getString(1) %>");
            </script>
    <%
        }
        /*** r5 ***/
        String r5_Query = "SELECT k.social_security_num, k.first_name, k.middle_name, k.last_name  "+
                          "FROM graduates x, student k "+
                          "WHERE x.student_id = k.student_id AND x.student_id IN (SELECT y.student_id "+
                                                                                  "FROM enrollment y, classes z "+
                                                                                  "WHERE y.c_number = z.c_number AND "+
                                                                                  "y.section_id = z.section_id AND "+
                                                                                    "z.quarter = 'Spring' AND "+
                                                                                  "z.s_year = 2023)";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(r5_Query);
    %>
        <script>var r5 = [];</script>
        <script>var r5_n = [];</script>
    <%
        while(rs.next()){
        %>
          <script>
            r5.push("<%= rs.getString(1) %>");
            r5_n.push("<%= ": " + rs.getString(2) +" "+ rs.getString(3) + " "+ rs.getString(4) %>");
          </script>
        <%
        }
        r5_Query = "SELECT * FROM ucsd_degree WHERE level = 'BS/MS' OR level = 'MS'";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(r5_Query);

    %>

        <script>var r5_d = [];</script>
    <%
        while(rs.next()){
    %>
            <script>
              r5_d.push("<%= rs.getString(3) + " in " + rs.getString(2) + " from department: " + rs.getString(1) %>");
            </script>
    <%
        }
        /*** r8 ***/
        String r8_Query = "SELECT DISTINCT quarter, s_year FROM classes ORDER BY(quarter)";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(r8_Query);
            %>
        <script>var r8 = [];</script>
  <%
        while(rs.next()){
    %>
            <script>
              r8.push("<%=rs.getString(1) + " " + rs.getString(2) %>");
            </script>
    <%
        }
        r8_Query = "SELECT DISTINCT f_name FROM teaching";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(r8_Query);
    %>
        <script>var r8_d = [];</script>
    <%
        while(rs.next()){
    %>
            <script>
              r8_d.push("<%=rs.getString(1)%>");
            </script>
    <%
        }
  %>



  <body>

  <%!
  public String json_reponse(String name,String value){
    return "\""+name+"\":\""+value+"\",";
  }

  public String json_reponse(String name,String[] value){
    String res = "\""+name+"\":\"{";
    for(int i=0;i<value.length;i++)
      res += "\"" + value[i] +"\"";
    res += "}\",";
    return res;
  }
  %>

    <div class="container">
    <div class="menu">
    <%@ page import="java.util.*" %>
    <%@ page language="java" import="java.util.HashMap" %>
      <%
      // not import java.util.HashMap
        //HashMap<String, String[]> page_tables=new HashMap<String, String[]>(){{
        //  put("student",new String[]{"section","student"});
        //  put("section",new String[]{"student"});
        //}};
        HashMap<String, String[]> page_tables = new HashMap<>();
        //populate hashmaps
        String[] student = new String[]{"student","undergraduates","graduates","previous_d","attendance"};
        //student tables
        page_tables.put("student",student);
        //faculty tables
        String[] faculty = new String[]{"faculty", "teaching"};
        page_tables.put("faculty", faculty);
        //course tables
        String[] course = new String[]{"course","prerequirement","cat_belong","con_belong","equivalent_num"};
        page_tables.put("course", course);
        //class tables
        String[] classes = new String[]{"section","classes", "weekly_meeting","teaching"};
        page_tables.put("classes",classes);
        //enrolment tables
        String[] enrollment = new String[]{"enrollment","waitlist"};
        page_tables.put("enrollment",enrollment);
        // class taken tables
        String[] classTaken = new String[]{"enrollment"};
        page_tables.put("class taken", classTaken);
        //thesis
        String[] thesis = new String[]{"thesis_committee","advisory"};
        page_tables.put("thesis",thesis);
        //probation tables
        String[] probation = new String[]{"probation"};
        page_tables.put("probation",probation);
        //review tables
        String[] review = new String[]{"review"};
        page_tables.put("review",review);
        //degree req tables
        String[] degree_req = new String[]{"ucsd_degree","cat_requirement","con_requirement"};
        page_tables.put("degree requirements", degree_req);
        //research tables
        String[] research = new String[]{"research","research_lead","work_on_research"};
        page_tables.put("research", research);
        // report 1
        String[] report1 = new String[]{};
        page_tables.put("report I", report1);
        // report II
        page_tables.put("report 2", new String[]{});
        // report 3
        String[] report3 = new String[]{};
        page_tables.put("report III", report3);
      %>

      <%
        String[] item_name = new String[]{"student","faculty","course","classes","enrollment","class taken", "thesis", "probation", "review", "degree requirements", "research", "report I", "report 2", "report III"};
        // String[] item_name = page_tables.keySet().toArray(new String[0]);
        String[] table_name = item_name;
        item_menu_get(table_name,item_name,out);
      %>
    </div>

    <!-- Create the main content area -->
    <div class="content" id="mainContent">
      <p>Click on a menu item to see the content.
      </p>


      <%
      /*
      // not uniform at all...need to tackle for each case
      // for report
      HashMap<String, String[]> page_report = new HashMap<>();
      String[] report2 = new String[]{"r2_a","r2_b"};
      page_report.put("report 2", report2);

      // for each report, list a query
      HashMap<String, String> report_query = new HashMap<>();
      report_query.put("r2_a", "")
      */
      %>

      <!-- set the scripting lang to java and sql -->
      <%@ page language="java" import="java.sql.*" %>
      <%@ page language="java" import="net.FTM" %>
      <%

        if (request.getMethod().equals("GET"))
          if (request.getParameterMap().containsKey("type")&&request.getParameter("type").equals("general")){
            String tablename=request.getParameter("table_name");

            if (! tablename.contains("report")){
              String[] related_tablename = page_tables.get(tablename);
              for(int i=0;i<related_tablename.length;i++){//
                String[][] res=FTM.tablename_schema_data(conn.createStatement(), related_tablename[i]);
                // entity_table(res,out,request.getParameter("table_name"));
                // maybe just render the data in the front end is easier to mange ???
                out.println(sql_js(res, related_tablename[i],"data_entity"));
              }
            } else { // just for report 
              if (tablename.equals("report I"))
              { %>
                <script> add_form("r1"); </script>
                <script> add_form("r2"); </script>
                <script> add_form("r3"); </script>
                <script> add_form("r4"); </script>
                <script> add_form("r5"); </script>
              <%
              } else if (tablename.equals("report III")){
              String[][] res=FTM.tablename_schema_data(conn.createStatement(), "course");
              out.println(sql_js(res, "course",""));
              %>
                <script> add_form("r8"); </script>
              <%
              // for report 2....here just the general, not details
              }else if (tablename.equals("report 2")){
                String query;
                String[][] res = null; 

                // a......all student names, SSN as argument
                String quarter = "Spring";// FTM.get_current_quarter_start()[0];
                int year = FTM.get_current_year();
                query =
                "create temporary table curr_section as " +
                "select distinct section_id from section where " +
                "s_year = "+year+ " and quarter = '"+ quarter +"';" +
                "create temporary table curr_student as " +
                "select distinct student_id from enrollment " +
                "where section_id in (select section_id from curr_section) and s_year = "+year +";"+
                "select first_name, last_name, middle_name, social_security_num from student where "+
                "student_id in (select student_id from curr_student)";
                
                res = FTM.query_schema_data(stmt, query);
                out.println(sql_js(res, "r2_a","data_select"));
                // out.println("<script>" + query +"</script>");

                // b....all available 
                // String[] quarter_start = FTM.get_current_quarter_start();
                query =
                // find all section in current quarter and year
                "select section_id from section where " +
                "s_year = '"+year+"' and quarter = '"+quarter+"'; " ;
                res = FTM.query_schema_data(stmt, query);
                out.println(sql_js(res, "r2_b","data_select")); // out.println("<script>" + query +"</script>");
              }
            }
        }
      %>
    </div>
  </div>





  <%
    try{
      conn.close();
    }catch(Exception e){
        out.println("fail with close connection");
        // out.println(e.printStackTrace());
        e.printStackTrace();
    }

  %>

  </body>




  </html>


