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


  <body>
    <div class="container">
    <%@ page import="java.util.*" %>
    <%@ page language="java" import="java.util.HashMap" %>

    <!-- Create the main content area -->
    <div class="content" id="mainContent">

      <!-- set the scripting lang to java and sql -->
      <%@ page language="java" import="java.sql.*" %>
      <%@ page language="java" import="net.FTM" %>
      <%

        if (request.getMethod().equals("GET"))
          if (request.getParameterMap().containsKey("table_name")){
            String table_name = request.getParameter("table_name");
            if (table_name.equals("r2_a")){
               String ssn = request.getParameter("social_security_num");
               int year = FTM.get_current_year();
               String quarter = FTM.get_current_quarter_start()[0];  
               String query = null;
               // get the student_id...primary key
               // get the section_id, s_year he has already taken
              query =
              // student id
              "CREATE TEMPORARY TABLE id as "+
              "select student_id from student where social_security_num = '"+ssn+"'; "+
              // section limited to current quarter and year
              "create temporary table curr_section as "+
              "select section_id, s_year from section "+
              "where s_year = '"+year+"' and quarter = '"+quarter+"'; " +
              // enrolled and not enrolled....student_id, also the year and quarter
              "create temporary table enrolled as " +
              "select e.section_id, e.s_year from enrollment e join curr_section c on " + // here do not use left join !!, remain null, thus even for left, still reamin
              "c.s_year = e.s_year and c.section_id = e.section_id "+
              "where e.student_id in (select student_id from id); "+
              // this way, no need for join !!!...from already limit the range
              /*
              "select section_id, s_year from curr_section " +
              "where "
              */
              // just all others for not enrolled
              "create temporary table not_enrolled as " +
              "select section_id, s_year from curr_section " +
              "where section_id not in (select section_id from enrolled); " +
              // weekly meeting
              "create temporary table enrolled_weekly as " +
              "select section_id, s_year, m_day, start_t, end_t from weekly_Meeting where "+
              "(section_id, s_year) in (select * from enrolled);" +
              "create temporary table not_enrolled_weekly as " +
              "select section_id, s_year, m_day, start_t, end_t from weekly_Meeting where "+
              "(section_id, s_year) in (select * from not_enrolled);" +
              // confliction....only distinct for year, s_id....to fiterout might be different year
              "create temporary table conflict as " +
              "select distinct no.section_id as no_id, no.s_year as no_year, yes.section_id as yes_id, yes.s_year as yes_year from "+
              "not_enrolled_weekly no join enrolled_weekly yes on " +
              "yes.s_year = no.s_year and " + // must also year, otherwise cross
              "yes.m_day = no.m_day and ((yes.start_t, yes.end_t) OVERLAPS (no.start_t, no.end_t));"+
              // get the corresponding course id, course title
              // for this translation, we can use the insert
              // I have 2 table, conflict(no_id , no_year, yes_id, yes_year) and class()
              // just like translation, still use "on" + join
              // what if 2 appear twice, just use denotion, classA, classB
              "create temporary table conflict_name as " +
              "select c1.s_year as coures_year, c1.c_number as course_id , c1.title as coures_title, "+ // lack ,
                      "c2.c_number as conflict_course_id , c2.title as conflict_coures_title "+
              "from conflict f "+ // target....syntax error, usually lack space
              // here if classes not register the section in 2022, still can't find
              "JOIN classes c1 ON f.no_id = c1.section_id AND f.no_year = c1.s_year "+  // translator
              "join classes c2 on f.yes_id = c2.section_id and f.yes_year = c2.s_year ; "+
              "select * from conflict_name;";

              // +"select * from conflict;";
               out.println("<h1> conflicting courses <h1> <br>");
               String[][] data = FTM.query_schema_data(stmt,query);
               out.println(sql_js(data, "r2_a","data_entity"));
            } else if (table_name.equals("r2_b")){
              // b.....all section involved
                int his_section_id = Integer.parseInt(request.getParameter("section_id"));
                String[] quarter_start = FTM.get_current_quarter_start();
                String quarter = quarter_start[0]; // should also try to use quarter filter out unrelated section
                String startday = quarter_start[1];
                int year = FTM.get_current_year();
                System.out.println(quarter +"  "+  year +"  "+ startday);

                String query =
                // first get all student from section
                "create temporary table enroll_std as " +
                "select student_id from enrollment where " +
                "s_year = '"+year+"' and section_id = '"+his_section_id+"'; " +

                // get all section
                "create temporary table all_section_year as " +
                "select distinct section_id from enrollment where " +
                "s_year = '"+year+"' and student_id in (select student_id from enroll_std); " +
                // at itself even if no one enroll !!
                "insert into all_section_year(section_id) values('"+his_section_id+"'); "+

                // all section in this quarter
                // since not combination , no need for on, where is enough
                "create temporary table all_section as " +
                "select a.section_id from all_section_year a where " +
                "a.section_id in (select s.section_id from section s where s.s_year = '"+year+"' and s.quarter = '"+quarter+"'); " +

                // get all sessions in weekly
                "create temporary table weekly as " +
                "select start_t, end_t, " +
                "   case m_day " +
                "       when 'M' then 1  " +
                "       when 'Tu' then 2  " +
                "       when 'W' then 3  " +
                "       when 'Th' then 4  " +
                "       when 'F' then 5  " +
                "       when 'Sa' then 6  " +
                "       when 'Su' then 7  " +
                "       else null " +
                "   end as weekday " +
                "from weekly_Meeting where " +
                "s_year = '"+year+"' and section_id in (select section_id from all_section); " +

                // review..single
                "create temporary table single as " +
                "select date, start_t, end_t from review where "+
                "s_year = '"+year+"' and section_id in (select section_id from all_section); "+
                // merge these 2....assume 10 weeks.....select function(),....use define map (case): M-->1, Tu-->2

                // all available date
                "create temporary table all_start_time as " +
                "WITH dates AS ( "+
                "    SELECT generate_series('" +startday+ "'::date, '" +startday+ "'::date + INTERVAL '70 days', '1 hour') AS generated_date) "+
                "SELECT generated_date FROM dates WHERE "+
                "1 <= EXTRACT(ISODOW FROM generated_date) and EXTRACT(ISODOW FROM generated_date) <= 5 and "+
                "8 <= EXTRACT(HOUR FROM generated_date) and EXTRACT(HOUR FROM generated_date) <= 19; "+
                // use interval to express of all range.....can't convert to time as it need the timestamp to extract the day of week
                "create temporary table all_range as "+
                "select generated_date as start_t, generated_date + INTERVAL '1 hour'  as end_t "+
                "from all_start_time; "+

                // select to add column, just use "as" --->  SELECT x, y, x + 2 AS x2, y + 2 AS y2
                // filter out the available day by weekly.....not on --> WHERE NOT EXISTS();
                // or   left join...on...where...is null;....join then, not matched....still not work
                // just use on not() !!!!!!!!
                // note if use join, it means inner join(and)....full join and left join is more safe
                // all join get full match pairs then elminate(fine for 1 row).....only WHERE NOT EXISTS (SELECT 1) eliminate
                "create temporary table available_range_weekly as "+
                "select r.start_t, r.end_t from all_range r where not exists (select 1 from weekly w where "+
                "EXTRACT(ISODOW FROM r.start_t) = w.weekday and "+
                "((r.start_t::TIMESTAMP::TIME, r.end_t::TIMESTAMP::TIME ) OVERLAPS (w.start_t, w.end_t))) "+
                "order by r.start_t asc, r.end_t asc; "+
                // extract can only extra 1 part
                // ((extract(time from r.start_t), extract(time from r.end_t) ) OVERLAPS (w.start_t, w.end_t));


                // filter out of the available day by single
                "create temporary table available_range as " +
                "select distinct r.start_t, r.end_t from available_range_weekly r where not exists (select 1 from single s  where "+
                "r.start_t::TIMESTAMP::date = s.date and "+
                "((r.start_t::TIMESTAMP::TIME, r.end_t::TIMESTAMP::TIME ) OVERLAPS (s.start_t, s.end_t))) "+
                "order by r.start_t asc, r.end_t asc; " +
                //
                // change to the format....must use ' not " to express

                " create temporary table available_range_format as "+
                " select start_t::TIMESTAMP::date as date, "+
                " case EXTRACT(ISODOW FROM start_t)   "+
                "        when 1 then 'Monday' "+
                "        when 2 then 'Tuesday' "+
                "        when 3 then 'Wednesday' "+
                "        when 4 then 'Thursday' "+
                "        when 5 then 'Friday' "+
                "        when 6 then 'Saturday' "+
                "        when 7 then 'Sunday' "+
                "        else null "+
                "    end::varchar(50) as weekday, "+
                "     start_t::TIMESTAMP::time as start_time, end_t::TIMESTAMP::time as end_time "+
                " from available_range; " +

                "select * from available_range_format; ";

                
                String[][] data = FTM.query_schema_data(stmt,query);
                out.println("<h1> available spot for arrange a review session <h1> <br>");
                out.println(sql_js(data, "data","data_entity"));
            }
          }
      %>
    </div>
  </div>

  <script>
  disable_all();
  </script>


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
