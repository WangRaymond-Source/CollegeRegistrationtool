package net;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.sql.DatabaseMetaData;
import java.util.ArrayList;

import javax.lang.model.util.ElementScanner14;
import java.util.*;
import java.sql.Driver;

import java.time.LocalDate;
import java.time.Month;

import java.sql.SQLException;

import java.io.BufferedReader;
import java.io.FileReader;

import java.io.StringWriter;
import java.io.PrintWriter;
// import com.mysql.jdbc.Driver;

public class FTM {
    public static void main(String[] args) {
        System.out.println(FTM.exist_db("tritonlink"));
        // delete

        /**/
        // get_current_quarter();

        // try{
        // Class.forName("com.mysql.cj.jdbc.Driver"); // this is in mysql
        String connURL = "jdbc:postgresql://localhost/tritonlink";// args[0]; //jdbc:postgresql://localhost/sample....
                                                                  // error with the url"postgresql" indicate type, can't
                                                                  // use triton...also affect the result
        String username = "postgres";// args[1]; //postgres
        String password = "123456";// args[2]; //12345
        connectAndTest(connURL, username, password);
        
    }

    // javac FTM.java -cp .:postgresql-42.5.0.jar
    // java -cp .:postgresql-42.5.0.jar FTM

    // with package net... get to direction containing net
    // javac net/FTM.java -cp .:postgresql-42.5.0.jar
    // java -cp .:postgresql-42.5.0.jar net/FTM

    public static String[][] string_java_sql(String[][] java_string, String[] java_string_name, String[][] sql_schema) {
        // for sql_schema, 1st line name, 2nd line type
        // return the string for sql according to column name -> column type
        // get the type for each column name
        String[] java_string_type = new String[java_string_name.length];
        try{
            for(int i=0;i<java_string_name.length;i++){
                int if_find = -1;
                for(int j=0;j<sql_schema[0].length;j++)
                    if (java_string_name[i].equals(sql_schema[0][j])){
                        if_find = j;
                        java_string_type[i] = sql_schema[1][j];
                        break;
                    }
                if (if_find == -1){
                    throw new Exception(java_string_name[i]+" not found");
                }
            }

            // convert the java_string to sql_string
            String[][] sql_string = new String[java_string.length][java_string[0].length];
            for (int i=0;i<java_string.length;i++){
                for(int j=0;j<java_string[i].length;j++){
                    String typename = java_string_type[j];
                    String sql_now = java_string[i][j];
                    if (typename.equals("varchar")){
                        sql_now = "'"+sql_now+"'";
                    } else if (typename.equals("bool") || typename.equals("int4") || typename.equals("serial") || typename.equals("float4") || typename.equals("time") || typename.equals("date")){
                        // same
                        sql_now = "'"+sql_now+"'"; // 'true' is also fine
                    }  else {
                        throw new Exception("unhandled type "+typename);
                    }
                    sql_string[i][j] = sql_now;
                }
            }

            return sql_string;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }




    public static void string2_print(String[][] res){
        System.out.println("total rows = "+res.length);
        int l = 650;
        if (res.length < l)
            l = res.length;
        for (int i = 0; i < l; i++) {
            for (int j = 0; j < res[i].length; j++)
                System.out.print(res[i][j] + "\t\t");
            System.out.println();
        }
        System.out.println("total rows = "+res.length);
    }


    public static void connectAndTest(String connURL, String userName, String password) {
        try {
            Connection conn = DriverManager.getConnection(connURL, userName, password);
            Statement stmt = conn.createStatement();
            System.out.println("connected");

            /*
            String table_name = "undergraduates";
            String[] schema = new String[]{"student_id","ucsd_college"};
            String[][] data = new String[][]{{"'A0000'","'Thurgood Marshall'"}};
            FTM.tablename_update(conn,table_name, schema,data);*/

            /*
            String[] schema = new String[] {"section_id","s_year","m_type","m_day","start_t","end_t","room","meeting_id"};
            String[] type_ = new String[] {"int4","int4","varchar","varchar","time","time","varchar","serial"};
            String[] data_origin = new String[]{"120","2023","DI","M","12:30:00","12:50:00","","10"};

            String[][] data = FTM.string_java_sql(new String[][]{data_origin}, schema, new String[][]{schema,type_});
            string2_print(data);
            */

            add_trigger_constraint(stmt);


            // Statement stmt = conn.createStatement();
            // tablename_key_foreigntable_key(conn,"course");


            // for test the jsp
            /*
            String table_name = "faculty";
            HashMap<String,String> request_data= new HashMap<String,String>(){{
                put("name", "Christopher");
                put("department","CSE");
                put("title","Professor");
            }};
            String table_name = "section";
            HashMap<String,String> request_data= new HashMap<String,String>(){{
                put("section_id", "132");
                put("s_year","2023");
                put("mandatory","true");
                put("enroll_limit","8");
                put("f_name","Christopher888");
            }};

            String table_name = "section";
            HashMap<String,String> request_data= new HashMap<String,String>(){{
                put("section_id", "132");
                put("s_year","2023");
                put("mandatory","true");
                put("enroll_limit","8");
                put("f_name","Christopher888");
            }};
            String table_name = "student";
            HashMap<String,String> request_data= new HashMap<String,String>(){{
                put("first_name", "132");
                put("last_name","2023");
                put("middle_name","true");
                put("social_security_num","8");
                put("student_id","100");
            }};


            String action_type = "delete";


            String[][] schema_type = FTM.tablename_schema(conn, table_name);
            string2_print(schema_type);
            String[] schema = schema_type[0] ; // 0-name, 1-type
            String[] data_origin = new String[schema.length];
            for (int i=0;i<data_origin.length;i++)
              data_origin[i] = request_data.get(schema[i]);
            // covert to sql data
            String[][] data = FTM.string_java_sql(new String[][]{data_origin}, schema, schema_type);

            // process the data
            boolean ifsuccess = false;
            if (action_type.equals("insert")){
              ifsuccess = FTM.tablename_insert(conn.createStatement(),table_name, schema,data);
              // localhost:8080/tritonlink/FTMweb_action.jsp?table_name=faculty&type=insert&name=Christopher&department=CSE&title=Professor
            } else if (action_type.equals("update")){
              ifsuccess = FTM.tablename_update(conn,table_name, schema,data);
              // localhost:8080/tritonlink/FTMweb_action.jsp?table_name=faculty&type=update&name=Christopher88&department=ECE&title=Professor
            } else if (action_type.equals("delete")){
              ifsuccess = FTM.tablename_delete(conn,table_name, schema,data);
              // localhost:8080/tritonlink/FTMweb_action.jsp?table_name=faculty&type=delete&name=Christopher8&department=ECE&title=Professor
            } else {
              System.out.print("fail unhandled action type "+action_type);
              throw new Exception("unhandled action type "+action_type);
            }
            System.out.println("'ifsuccess':"+ifsuccess+",");
            if (!ifsuccess){
              System.out.println("'failure_detail': '(java)\t");
              for(int i=0;i<schema_type[1].length;i++)
                System.out.print(schema_type[1][i]+"\t");
              for(int i=0;i<data[0].length;i++)
                System.out.print(data[0][i]+"\t");
              System.out.println("',");
            }
*/
            /*
            String ssn = "12345";
            int year = FTM.get_current_year();
            String quarter = FTM.get_current_quarter_start()[0];
*/
            /*
            String query2;
            String query = "select section_id, s_year from enrollment where student_id in "+
            "(select student_id from student where social_security_num = '12345');";

            query2 = "(select section_id, s_year from enrollment where student_id = "+
            "(select student_id from student where social_security_num = '12345')) enrolled, ";

            query2 = " where (select x.section_id, x.s_year from "+
            "enrollment x, student y where y.social_security_num = '" + ssn + "') enroll_section, "+
            "(select x.section_id, x.s_year from "+
            "enrollment x, student y where y.social_security_num != '" + ssn + "') not_section, "
            ;

            select section_id, s_year, m_day, start_t, end_t from weekly_Meeting where
            (section_id, s_year) in
            (select section_id, s_year from enrollment where student_id in
            (select student_id from student where social_security_num = '12345')) en
             (select section_id, s_year from enrollment where student_id not in
            (select student_id from student where social_security_num = '12345')) un where
            */

            /*
            String query =
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

            "select section_id, s_year from curr_section " +
            "where "
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
            */

            // get current encrolled student






            // "select * from enrolled_weekly;";

            int his_section_id = 132;
            String[] quarter_start = FTM.get_current_quarter_start();
            String quarter = quarter_start[0]; // should also try to use quarter filter out unrelated section
            String startday = quarter_start[1];
            int year = FTM.get_current_year();
            System.out.println(quarter +"  "+  year +"  "+ startday);

/*
            String query =
            // find all section in current quarter and year
            "select section_id from section where " +
            "s_year = '"+year+"' and quarter = '"+quarter+"'; " ;

            */

            /*
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

            // all available date.........?????
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

*/
//




/*
            CREATE TEMPORARY TABLE id as
            select student_id from student where social_security_num = '12345';
            create temporary table enrolled as
            select section_id, s_year from enrollment where student_id in student_id;
*/
            /*
            Statement stmt = conn.createStatement();
            stmt.execute(query);
            query = "select * from id;";
            */
            // "select section_id, s_year from enrollment where student_id in id.student_id; ";


            // query = "select student_id from student where social_security_num = '12345';";
            //create temporary table en_section as


            // String[][] res = query_schema_data(conn.createStatement(), query);
            // string2_print(res);
/*
            // just for test
            String query = "SELECT x.student_id " +
            "FROM enrollment x, classes y "+
            "WHERE x.c_number = y.c_number AND "+
            "x.s_year = y.s_year AND "+
            "y.quarter = 'Spring'";

            query = "select * from student;";
            String[][] res = query_schema_data(conn.createStatement(), query);
            string2_print(res);
            System.out.println("==============end view=======");
*/
/*            
            String table_name = "student";
            String[][] res = tablename_schema_data(conn.createStatement(), table_name);
            string2_print(res);
            System.out.println("==============end view=======");


            String[][] datas = new String[][]{
            {"'1002'", "'Alice'", "'Smith'", "'L.'", "'123-45-6789'", "true"},
            {"'1003'", "'Bob'", "'Johnson'", "'K.'", "'987-65'", "false"}
            };

            String[][] java_datas = new String[][]{
            {"1002", "Alice", "Smith", "L.", "123-45-6789", "true"},
            {"1003", "Bob", "Johnson", "K.", "987-65888", "false"}
            };

            string2_print(java_datas);
            System.out.println("==========compare============");
            // String_java_sql(String[][] java_string, String[] java_string_name, String[][] sql_schema)
            ;
            String[][] sql_datas = string_java_sql(java_datas, res[0],res);
            string2_print(sql_datas);
            tablename_update(conn, table_name, res[0], sql_datas);
            */



            // tablename_insert(conn.createStatement(), table_name, res[0], datas);

            //
            // System.out.println("only schema !");
            // String[][] sql_schema = tablename_schema(conn, table_name);
            // string2_print(sql_schema);

            // System.out.println("Below is the primary key");
            // tablename_delete(conn, table_name, res[0], datas);

            /*
             * Statement stmt = conn.createStatement();
             * //influence table
             * stmt.executeUpdate("DROP TABLE IF EXISTS influence;");
             * // System.out.println("Table droped: influence");
             * stmt.
             * executeUpdate("CREATE TABLE influence(who varchar(255), whom varchar(255));"
             * );
             * // System.out.println("Table influence created");
             * 
             * //table start
             * stmt.executeUpdate("DROP VIEW IF EXISTS T");
             * 
             * //[t=g] populate t
             * stmt.
             * executeUpdate("CREATE VIEW T AS(SELECT DISTINCT d1.cname AS who, d2.cname AS whom FROM transfer, depositor d1, depositor d2 where src = d1.ano AND tgt = d2.ano);"
             * );
             * 
             * stmt.executeUpdate("INSERT INTO influence SELECT * FROM T;");
             * 
             * 
             * //double recursion
             * ResultSet size =
             * stmt.executeQuery("SELECT COUNT(*) AS total FROM influence");
             * size.next();
             * int delta = size.getInt("total");
             * // System.out.println("num:" + delta);
             * while(delta != 0){
             * ResultSet To = stmt.executeQuery("SELECT COUNT(*) AS total FROM influence");
             * To.next();
             * int tOld = To.getInt("total");
             * 
             * 
             * //this is the recursive part of the algorithm
             * stmt.
             * executeUpdate("INSERT INTO influence SELECT x.who, y.whom FROM influence x, influence y WHERE x.whom = y.who EXCEPT SELECT * FROM influence;"
             * );
             * 
             * 
             * 
             * 
             * 
             * ResultSet tn = stmt.executeQuery("SELECT COUNT(*) AS total FROM influence");
             * tn.next();
             * int tNew = tn.getInt("total");
             * 
             * //update delta
             * delta = tNew - tOld;
             * }
             * ResultSet rs = stmt.executeQuery("SELECT * FROM influence");
             * // prints out all of the relations
             * while(rs.next()){
             * System.out.println("who : " + rs.getString("who"));
             * System.out.println("whom : " + rs.getString("whom"));
             * System.out.println();
             * }
             * // DROP table start
             * stmt.executeUpdate("DROP VIEW IF EXISTS T");
             * 
             */
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String[] get_current_quarter_start(){
        // get the current quarter and start of day

        // Getting the current date value
        LocalDate curr = LocalDate.now();
        int year = curr.getYear();

        // compare to get know th quarter
        LocalDate winter = LocalDate.of(year, 1, 4);
        LocalDate spring = LocalDate.of(year, 3, 29);
        LocalDate summer1 = LocalDate.of(year, 7, 3);
        LocalDate summer2 = LocalDate.of(year, 8, 7);
        LocalDate fall = LocalDate.of(year, 9, 8);

        String quarter = null;
        String quarter_start = null;
        if (curr.isAfter(winter) && curr.isBefore(spring)) {
            quarter = "Winter";
            quarter_start = winter.toString();
        } else if (curr.isAfter(spring) && curr.isBefore(summer1)) {
            quarter = "Spring";
            quarter_start = spring.toString();
        } else if (curr.isAfter(summer1) && curr.isBefore(summer2)) {
            quarter = "Summer I";
            quarter_start = summer1.toString();
        } else if (curr.isAfter(summer2) && curr.isBefore(fall)) {
            quarter = "Summer II";
            quarter_start = summer2.toString();
        } else if (curr.isAfter(fall)) {
            quarter = "Fall";
            quarter_start = fall.toString();
        }
        // System.out.println(quarter);
        return new String[]{quarter, quarter_start};
    }

    public static int get_current_year(){
        // Getting the current date value
        LocalDate curr = LocalDate.now();
        int year = curr.getYear();
        // System.out.println(quarter);
        return year;
    }

    public static String[][] tablename_schema(Connection conn, String table_name) {
        // ArrayList<String[]> res = new ArrayList<String[]>();
        String[][] res = new String[2][];
        try {
            DatabaseMetaData metadata = conn.getMetaData();
            ResultSet rs = metadata.getColumns(null, null , table_name, null); // schemaName ??

            // schema name & type
            ArrayList<String> column_name = new ArrayList<String>();
            ArrayList<String> column_type = new ArrayList<String>();
            while (rs.next()) {
                //String columnName = rs.getString("COLUMN_NAME");
                //String columnType = rs.getString("TYPE_NAME");
                //System.out.println(columnName + " " + columnType);
                column_name.add(rs.getString("COLUMN_NAME"));
                column_type.add(rs.getString("TYPE_NAME"));
            }
            res[0] = column_name.toArray(new String[0]);
            res[1] = column_type.toArray(new String[0]);

            return res;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    // get result from query
    public static String[][] query_schema_data(Statement stmt, String query) {
        // stmt.executeUpdate();
        ArrayList<String[]> res = new ArrayList<String[]>();
        try {
            // ResultSet rs = stmt.executeQuery("SELECT * FROM " + table_name + ";");
            String[] query_list = query.split(";");
            int l = query_list.length;
            if (query_list[l-1].replaceAll(" ","").equals("")){
                System.out.println("last one null");
                l --;
            }

            for(int i=0; i<l-1; i++){ // maybe temporary
                System.out.println("___"+query_list[i]);
                stmt.execute(query_list[i]);
            }

            System.out.println("___"+query_list[l-1]);
            // last one must not blank
            ResultSet rs = stmt.executeQuery(query_list[l-1]);
            
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnsCount = rsmd.getColumnCount();

            // schema name
            ArrayList<String> single = new ArrayList<String>();
            for (int i = 1; i <= columnsCount; i++)
                single.add(rsmd.getColumnName(i));
            res.add(single.toArray(new String[0]));

            // schema type
            single = new ArrayList<String>();
            for (int i = 1; i <= columnsCount; i++)
                single.add(rsmd.getColumnTypeName(i));
            res.add(single.toArray(new String[0]));

            // data
            while (rs.next()) {
                single = new ArrayList<String>();
                // xx += rs.getString(1)+"<br>";
                for (int i = 1; i <= columnsCount; i++)
                    single.add(rs.getString(i));
                // xx += "__"+ rs.getString(i);
                // System.out.println(xx);
                res.add(single.toArray(new String[0]));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res.toArray(new String[0][]);
    }

    public static String[][] tablename_schema_data(Statement stmt, String table_name) {
        // stmt.executeUpdate();
        ArrayList<String[]> res = new ArrayList<String[]>();
        try {
            ResultSet rs = stmt.executeQuery("SELECT * FROM " + table_name + ";");
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnsCount = rsmd.getColumnCount();

            // schema name
            ArrayList<String> single = new ArrayList<String>();
            for (int i = 1; i <= columnsCount; i++)
                single.add(rsmd.getColumnName(i));
            res.add(single.toArray(new String[0]));

            // schema type
            single = new ArrayList<String>();
            for (int i = 1; i <= columnsCount; i++)
                single.add(rsmd.getColumnTypeName(i));
            res.add(single.toArray(new String[0]));

            // data
            while (rs.next()) {
                single = new ArrayList<String>();
                // xx += rs.getString(1)+"<br>";
                for (int i = 1; i <= columnsCount; i++)
                    single.add(rs.getString(i));
                // xx += "__"+ rs.getString(i);
                // System.out.println(xx);
                res.add(single.toArray(new String[0]));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res.toArray(new String[0][]);
    }

    public static String[] table_name_all(DatabaseMetaData metadata){
        try {
            // Get database metadata
            ArrayList<String> res = new ArrayList<String>();

            // Get all table names
            ResultSet resultSet = metadata.getTables(null, null, null, new String[]{"TABLE"});
            while (resultSet.next()) {
                res.add(resultSet.getString("TABLE_NAME"));
                // System.out.println(resultSet.getString("TABLE_NAME"));
            }
            return res.toArray(new String[0]);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static HashMap<String,HashMap<String,String>> tablename_key_foreigntable_key(Connection conn, String table_name) {
        // get all tables who have a foreign key referencing this table
        try {
            DatabaseMetaData metadata = conn.getMetaData();
            // get all the table
            String[] tables = table_name_all(metadata);

            // foreign_table, primary_key ---> foreign_key   .... translate
            HashMap<String,HashMap<String,String>> foreign_primary_key = new HashMap<String,HashMap<String,String>>();
            for (String table_f:tables){
                ResultSet resultSet = metadata.getImportedKeys(null, null, table_f);
                while (resultSet.next()) {
                    String pkTableName = resultSet.getString("PKTABLE_NAME");
                    String pkColumnName = resultSet.getString("PKCOLUMN_NAME");
                    // String fkName = resultSet.getString("FK_NAME");
                    String fkColumnName = resultSet.getString("FKCOLUMN_NAME");
                    if (pkTableName.equals(table_name)){
                        if(!foreign_primary_key.containsKey(table_f)){
                            foreign_primary_key.put(table_f,new HashMap<String,String>());
                        }
                        foreign_primary_key.get(table_f).put(pkColumnName,fkColumnName);
                    }
                    /*
                    System.out.println("Foreign Key Name: " + fkName);
                    System.out.println("Foreign Key Column: " + fkColumnName);
                    System.out.println("Primary Key Table: " + pkTableName);
                    System.out.println("Primary Key Column: " + pkColumnName);
                    System.out.println();*/
                }
                // try to print out
                if (foreign_primary_key.containsKey(table_f)){
                    System.out.println("=============check for "+table_f+"===============");
                    HashMap<String,String> primary_foreign = foreign_primary_key.get(table_f);
                    for(String primary : primary_foreign.keySet())
                        System.out.println(primary + "  -->  " + primary_foreign.get(primary));
                }
            }
            return foreign_primary_key;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /*
     * public static String[][] tablename_schema(Statement stmt, String table_name)
     * {
     * // stmt.executeUpdate();
     * ArrayList<String[]> res = new ArrayList<String[]>();
     * try {
     * ResultSet rs = stmt.executeQuery("SELECT * FROM " + table_name + ";");
     * ResultSetMetaData rsmd = rs.getMetaData();
     * int columnsCount = rsmd.getColumnCount();
     * while (rs.next()) {
     * ArrayList<String> single = new ArrayList<String>();
     * // xx += rs.getString(1)+"<br>";
     * for (int i = 1; i <= columnsCount; i++)
     * single.add(rs.getString(i));
     * // xx += "__"+ rs.getString(i);
     * // System.out.println(xx);
     * res.add(single.toArray(new String[0]));
     * }
     * } catch (Exception e) {
     * e.printStackTrace();
     * }
     * return res.toArray(new String[0][]);
     * }
     */

    public static String[] tablename_insert(Statement stmt, String table_name, String[] schema, String[][] datas) {
        String sql_insert = "";
        try {
            sql_insert = "INSERT INTO "+table_name+" (";
            // schema
            for (int i = 0; i < schema.length - 1; i++)
                sql_insert += schema[i] + ",";
            sql_insert += schema[schema.length - 1] + ") VALUES ";

            // value
            for (int k=0;k<datas.length;k++){
                String[] data = datas[k];

                sql_insert += "(";

                for (int i = 0; i < data.length - 1; i++)
                    sql_insert += data[i] + ",";
                sql_insert +=  data[data.length - 1] + ")";

                // for different data
                if (k == datas.length-1)
                    sql_insert += ";";
                else
                    sql_insert += ",";
            }

            System.out.println(sql_insert);

            // execute
            stmt.executeUpdate(sql_insert);

            return new String[]{"T", sql_insert};
        } catch (SQLException e) {
            System.out.println("sql Message: \n" + e.getMessage());
            return new String[]{"F", sql_insert, e.getMessage()};
        } catch (Exception e) {
            e.printStackTrace();
            return new String[]{"F", sql_insert};
        }
    }

    public static boolean[] schema_ifprimary(Connection conn, String table_name, String[] schema){

        // what if no primary key ???  incomplete primary key ???
        // check schema completeness to avoid update to much date ???
        try {
            DatabaseMetaData metadata = conn.getMetaData();
            ResultSet rs = metadata.getPrimaryKeys(null, null, table_name);
            boolean[] if_primary = new boolean[schema.length];
            for(int i=0;i<schema.length;i++)    if_primary[i] = false;
            while (rs.next()) {
                String columnName = rs.getString("COLUMN_NAME"); // this is what we want
                int find_idx=-1;
                for(int i=0;i<schema.length;i++)
                    if (columnName.equals(schema[i])){
                        find_idx = i;
                        break;
                    }
                if (find_idx != -1){
                    if_primary[find_idx] = true;
                } else {
                    throw new Exception("primary key not foundd ! ___"+columnName);
                }

                // String pkName = rs.getString("PK_NAME");
                // int keySeq = rs.getShort("KEY_SEQ");
                // System.out.println("Primary key column: " + columnName); // this
                // System.out.println("Primary key name: " + pkName);
                // System.out.println("Primary key sequence: " + keySeq);
            }
            return if_primary;

        }  catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean[] schema_ifforeign(Connection conn, String table_name, String[] schema){
        // what if no primary key ???  incomplete primary key ???
        // check schema completeness to avoid update to much date ???
        try {
            DatabaseMetaData metadata = conn.getMetaData();
            ResultSet rs = metadata.getImportedKeys(null, null, table_name);
            boolean[] if_primary = new boolean[schema.length];
            for(int i=0;i<schema.length;i++)    if_primary[i] = false;
            while (rs.next()) {
                String columnName = rs.getString("FKCOLUMN_NAME"); // this is what we want
                int find_idx=-1;
                for(int i=0;i<schema.length;i++)
                    if (columnName.equals(schema[i])){
                        find_idx = i;
                        break;
                    }
                if (find_idx != -1){
                    if_primary[find_idx] = true;
                } else {
                    throw new Exception("foreign key not foundd ! ___"+columnName);
                }

                // String pkName = rs.getString("PK_NAME");
                // int keySeq = rs.getShort("KEY_SEQ");
                // System.out.println("Primary key column: " + columnName); // this
                // System.out.println("Primary key name: " + pkName);
                // System.out.println("Primary key sequence: " + keySeq);
            }
            return if_primary;

        }  catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // make sure entity has no foreign key...to distinguish from primary key
    public static String[] tablename_update(Connection conn, String table_name, String[] schema, String[][] datas) {
        String sql_s = "";
        try {
            // first get the primary primary
            boolean[] if_primary = schema_ifprimary(conn, table_name,schema);
            boolean[] if_foreign = schema_ifforeign(conn, table_name,schema);

            /**/
            // get last idx to avoid add ,
            int last_primary_idx = -1;
            int last_foreign_idx = -1;
            int last_non_idx = -1;
            for(int i=0;i<schema.length;i++)
                if(if_primary[i]){
                    last_primary_idx = i;
                    System.out.println(schema[i]+"--->primary");
                }else if(if_foreign[i]){
                    last_foreign_idx = i;
                    System.out.println(schema[i]+"--->foreign");
                }else{
                    last_non_idx = i;
                    System.out.println(schema[i]+"--->non");
                }
            // System.out.println("last_primary_idx = "+last_primary_idx);
            // System.out.println("last_foreign_idx = "+last_foreign_idx);
            // System.out.println("last_non_idx = "+last_non_idx);

            //UPDATE student set first_name = 'Jonathan', last_name = 'Doe', middle_name = 'J.', social_security_num = '123-45-6789', is_enrolled = true WHERE student_id = '1001';
            // must use ', not " ... error
            // update data
            Statement stmt = conn.createStatement();

            for (int k=0;k<datas.length;k++){
                String[] data = datas[k];
                String sql_update = "UPDATE "+table_name+" set ";
                // update part---non
                for (int i=0;i<=last_non_idx;i++)
                    if (!(if_primary[i])){ // ||if_foreign[i] // now not use foreign key and primary at same time...thus just exclude primary key...or miss Info
                    // UPDATE weekly_meeting set m_type='DI',m_day='M',start_t='08:30:00',end_t='11:00:00',room='' where meeting_id='1'
                        sql_update += schema[i] +"="+ data[i];
                        if (i < last_non_idx)
                            sql_update += ",";
                    }
// UPDATE student set first_name='Alice',last_name='Smith,middle_name='L.',social_security_num='123-45-6789',is_enrolled=true where student_id='1002';

                // where part---by primary key..if there is primary key
                sql_update += " where ";
                if(last_primary_idx >=0){ // use primary key or foreign key
                    for (int i=0;i<=last_primary_idx;i++)
                        if (if_primary[i]){
                            sql_update += schema[i] +"="+ data[i];
                            if (i < last_primary_idx)
                                sql_update += " and ";
                        }
                } else{
                    // where by foreign key
                    sql_update += "(";
                    for (int i=0;i<=last_foreign_idx;i++)
                        if (if_foreign[i]){
                            sql_update += schema[i] +"="+ data[i];
                            if (i < last_foreign_idx)
                                sql_update += " and ";
                        }
                    sql_update += ")";
                }

                sql_update += ";";


                System.out.println(sql_update);
                sql_s += sql_update;

                // execute
                stmt.executeUpdate(sql_update);
            }

            return new String[]{"T", sql_s};
        } catch (SQLException e) {
            System.out.println("sql Message: \n" + e.getMessage());
            return new String[]{"F", sql_s, e.getMessage()};
        } catch (Exception e) {
            e.printStackTrace();
            return new String[]{"F", sql_s};
        }
    }

    public static boolean tablename_delete_old(Connection conn, String table_name, String[] schema, String[][] datas) {
        // this only delete itself
        try {
            // first get the primary primary
            boolean[] if_primary = schema_ifprimary(conn, table_name,schema);

            /**/
            // get last idx to avoid add ,
            int last_primary_idx = -1;
            int last_non_idx = -1;
            for(int i=0;i<schema.length;i++)
                if(if_primary[i])
                    last_primary_idx = i;
                else
                    last_non_idx = i;

            //UPDATE student set first_name = 'Jonathan', last_name = 'Doe', middle_name = 'J.', social_security_num = '123-45-6789', is_enrolled = true WHERE student_id = '1001';
            // must use ', not " ... error
            // delete data
            Statement stmt = conn.createStatement();

            for (int k=0;k<datas.length;k++){
                String[] data = datas[k];
                String sql_delete = "delete from "+table_name;
                // where part---primary
                sql_delete += " where ";
                for (int i=0;i<=last_primary_idx;i++)
                    if (if_primary[i]){
                        sql_delete += schema[i] +"="+ data[i];
                        if (i < last_primary_idx)
                            sql_delete += " and ";
                    }
                sql_delete += ";";


                System.out.println(sql_delete);

                // execute
                stmt.executeUpdate(sql_delete);
            }

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static String[] tablename_delete(Connection conn, String table_name, String[] schema, String[][] datas) {
        // this try to delete all related
        String sql_s = "";
        try {
            boolean[] if_primary = schema_ifprimary(conn, table_name,schema);
            boolean[] if_foreign = schema_ifforeign(conn, table_name,schema);

            /**/
            // get last idx to avoid add ,
            int last_primary_idx = -1;
            int last_foreign_idx = -1;
            int last_non_idx = -1;
            for(int i=0;i<schema.length;i++)
                if(if_primary[i]){
                    last_primary_idx = i;
                }else if(if_foreign[i]){
                    last_foreign_idx = i;
                }else{
                    last_non_idx = i;
                }

            // get all related foreign table_key
            HashMap<String,HashMap<String,String>> foreign_table_key= tablename_key_foreigntable_key( conn, table_name);

            //UPDATE student set first_name = 'Jonathan', last_name = 'Doe', middle_name = 'J.', social_security_num = '123-45-6789', is_enrolled = true WHERE student_id = '1001';
            // must use ', not " ... error
            // update data
            Statement stmt = conn.createStatement();

            // create cmd, then execute
            HashMap<String,String> sql_related_delete = new HashMap<String,String>();
            String sql_delete;
            // for (int k=0;k<datas.length;k++){
            // String[] data = datas[k];
            for(String[] data : datas){
                // start
                for(String table_t : foreign_table_key.keySet())
                    sql_related_delete.put(table_t, "delete from " + table_t + " where ");
                sql_delete = "delete from "+table_name + " where "; // can't merge, itself no need to translate

                // where part---primary

                // related
                for(String table_f : foreign_table_key.keySet()){
                    String related_sql = sql_related_delete.get(table_f);
                    HashMap<String,String> primary_key_translate = foreign_table_key.get(table_f);
                    for(int i=0;i<=last_primary_idx;i++)
                        if (if_primary[i]){
                            System.out.println(i+"\t"+last_primary_idx);
                            related_sql +=  primary_key_translate.get(schema[i]) +"="+ data[i];
                            if (i < last_primary_idx)
                                related_sql += " and "; // should change the symbol from sql_delete to related_sql
                        }
                    related_sql += " ;";
                    sql_related_delete.put(table_f, related_sql);
                    System.out.println(related_sql);
                    // record
                    sql_s += table_f +"   --->   " + sql_related_delete.get(table_f); //  + "\n"; can't contain line break
                }

                // itself---primary key
                if (last_primary_idx >= 0){
                for (int i=0;i<=last_primary_idx;i++)
                    if (if_primary[i]){
                        sql_delete += schema[i] +"="+ data[i];
                        if (i < last_primary_idx)
                            sql_delete += " and ";
                    }
                } else {
                    // where by foreign key
                    sql_delete += "(";
                    for (int i=0;i<=last_foreign_idx;i++)
                        if (if_foreign[i]){
                            sql_delete += schema[i] +"="+ data[i];
                            if (i < last_foreign_idx)
                                sql_delete += " and ";
                        }
                    sql_delete += ")";
                }

                sql_delete += " ;";
                // record
                sql_s += sql_delete;


                // print out + execute
                for(String table_f : sql_related_delete.keySet()){
                    System.out.println(table_f +"   --->   " + sql_related_delete.get(table_f));
                    stmt.executeUpdate(sql_related_delete.get(table_f));
                }
                System.out.println(sql_delete);
                stmt.executeUpdate(sql_delete);
            }

            return new String[]{"T", sql_s};
        } catch (SQLException e) {
            System.out.println("sql Message: \n" + e.getMessage());
            return new String[]{"F", sql_s, e.getMessage()};
        } catch (Exception e) {
            e.printStackTrace();
            return new String[]{"F", sql_s};
        }
    }

    public static String[] path_execute_sql(String sql_path, Statement stmt){
        String sql_s="";
        try{
            BufferedReader reader = new BufferedReader(new FileReader(sql_path));

            StringBuilder sqlBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sqlBuilder.append(line);
                sqlBuilder.append("\n");
            }

            sql_s = sqlBuilder.toString();
            stmt.executeUpdate(sql_s);
            System.out.println("SQL file executed successfully.");

            return new String[]{"T", sql_s};
        } catch (SQLException e) {
            System.out.println("sql Message: \n" + e.getMessage());
            return new String[]{"F", sql_s, e.getMessage()};
        } catch (Exception e) {
            e.printStackTrace();

            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            String stackTrace = sw.toString();
            return new String[]{"F", sql_s, stackTrace};
        }
    }

    public static String[] add_trigger_constraint(Statement stmt){
        return path_execute_sql("net/trigger_constraint.sql", stmt); // path is defined as relative to the running path, namely the java xxxx running path
    }


    public static String delete_db(String database_name){
        String xx="not executed";
        try{
            // DriverManager.registerDriver(new org.postgresql.Driver());
            // Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/tritonlink?user=postgres&password=123456");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
            Statement stmt = conn.createStatement();

            // conn.setAutoCommit(false); // DROP DATABASE cannot run inside a transaction block
            // Drop the database
            String sql = "DROP DATABASE "+database_name+";";
            stmt.executeUpdate(sql);
            // Commit the transaction
            // conn.commit();

            xx = "success";

            conn.close();

        }catch(Exception e){
            e.printStackTrace();
            xx = "fail___"+xx;
        }

        return xx;
    }

    public static String create_db(String database_name){
        String xx="not executed";
        try{
            // DriverManager.registerDriver(new org.postgresql.Driver());
            // Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/tritonlink?user=postgres&password=123456");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
            Statement stmt = conn.createStatement();

            // conn.setAutoCommit(false);
            // create the database
            String sql = "CREATE DATABASE "+database_name+";";
            stmt.executeUpdate(sql);
            // Commit the transaction
            // conn.commit();

            xx = "success";

            conn.close();

        }catch(Exception e){
            e.printStackTrace();
            xx = "fail___"+xx;
        }

        return xx;
    }

    public static boolean exist_db(String database_name){
        boolean ifexist = false;
        try{
            // DriverManager.registerDriver(new org.postgresql.Driver());
            // Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/tritonlink?user=postgres&password=123456");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
            Statement stmt = conn.createStatement();

            /*
            conn.setAutoCommit(false);
            // Drop the database
            String sql = "DROP DATABASE "+database_name+";";
            stmt.executeUpdate(sql);
            // Commit the transaction
            conn.commit();
            */

            // Query the system catalog to check if the database exists
            String sql = "SELECT datname FROM pg_catalog.pg_database WHERE datname = '" + database_name + "'";
            ResultSet resultSet = stmt.executeQuery(sql);

            if (resultSet.next()) {
                ifexist = true;
            } else {
                ifexist = false;
            }

            conn.close();

        }catch(Exception e){
            e.printStackTrace();
        }

        return ifexist;

    }

}


/*
CREATE TEMPORARY TABLE id as
            select student_id from student where social_security_num = '12345';
            select * from id;
create temporary table enrolled as select section_id, s_year from enrollment where student_id in (select student_id from id);
create temporary table not_enrolled as select section_id, s_year from section where s_year in (select s_year from enrolled) and section_id not in (select section_id from enrolled);
create temporary table enrolled_weekly as select section_id, s_year, m_day, start_t, end_t from weekly_Meeting where (section_id, s_year) in (select * from enrolled);
create temporary table not_enrolled_weekly as select section_id, s_year, m_day, start_t, end_t from weekly_Meeting where (section_id, s_year) in (select * from not_enrolled);
create temporary table conflict as select distinct no.section_id as no_id, no.s_year as no_year, yes.section_id as yes_id, yes.s_year as yes_year from not_enrolled_weekly no join enrolled_weekly yes on yes.m_day = no.m_day and (yes.start_t, yes.end_t) OVERLAPS (no.start_t, no.end_t);
select c1.c_number as course_id , c1.title as coures_title, c2.c_number as conflict_course_id , c2.title as conflict_coures_title from conflict f JOIN classes c1 ON f.no_id = c1.section_id AND f.no_year = c1.s_year join classes c2 on f.yes_id = c2.section_id and f.yes_year = c2.s_year ;



*/

/*
create temporary table curr_section as
select distinct section_id from section where
s_year = 2023 and quarter = 'Spring';
create temporary table curr_student as
select distinct student_id from enrollment
where section_id in (select section_id from curr_section) and s_year = 2023;
select first_name, last_name, middle_name, social_security_num from student where
student_id in (select student_id from curr_student);
*/







/*
report 2b

// first get all student from section
            create temporary table enroll_std as
            select student_id from enrollment where
            s_year = '2023' and section_id = '132';
            // get all section
            create temporary table all_section_year as
            select distinct section_id from enrollment where
            s_year = '2023' and student_id in (select student_id from enroll_std);

            // since not combination , no need for on, where is enough
            create temporary table all_section as
            select a.section_id from all_section_year a where
            a.section_id in (select s.section_id from section s where s.s_year = '2023' and s.quarter = 'Spring');

            // get all sessions in weekly
            create temporary table weekly as
            select start_t, end_t,
                case m_day
                    when 'M' then 1
                    when 'Tu' then 2
                    when 'W' then 3
                    when 'Th' then 4
                    when 'F' then 5
                    when 'Sa' then 6
                    when 'Su' then 7
                    else null
                end as weekday
            from weekly_Meeting where
            s_year = '2023' and section_id in (select section_id from all_section);


            // review..single
            create temporary table single as
            select date, start_t, end_t from review where
            s_year = '2023' and section_id in (select section_id from all_section);
            // merge these 2....assume 10 weeks.....select function(),....use define map (case): M-->1, Tu-->2



            // all available date
            create temporary table all_start_time as
            WITH dates AS (
                SELECT generate_series('2023-05-01'::date, '2023-05-01'::date + INTERVAL '70 days', '1 hour') AS generated_date
            )
            SELECT generated_date FROM dates WHERE
            1 <= EXTRACT(ISODOW FROM generated_date) and EXTRACT(ISODOW FROM generated_date) <= 5 and
            8 <= EXTRACT(HOUR FROM generated_date) and EXTRACT(HOUR FROM generated_date) <= 19;
            // use interval to express of all range.....can't convert to time as it need the timestamp to extract the day of week
            create temporary table all_range as
            select generated_date as start_t, generated_date + INTERVAL '1 hour'  as end_t
            from all_start_time;
            // select to add column, just use "as" --->  SELECT x, y, x + 2 AS x2, y + 2 AS y2
            // filter out the available day by weekly.....not on --> WHERE NOT EXISTS();
            // or   left join...on...where...is null;....join then, not matched....still not work
            // just use on not() !!!!!!!!
            create temporary table available_range_weekly as
            select r.start_t, r.end_t from all_range r JOIN weekly w on not(
            EXTRACT(ISODOW FROM r.start_t) = w.weekday and
            ((r.start_t::TIMESTAMP::TIME, r.end_t::TIMESTAMP::TIME ) OVERLAPS (w.start_t, w.end_t)));
            // extract can only extra 1 part
            // ((extract(time from r.start_t), extract(time from r.end_t) ) OVERLAPS (w.start_t, w.end_t));

            // filter out of the available day by single
            create temporary table available_range as
            select r.start_t, r.end_t from available_range_weekly r JOIN single s on not(
            r.start_t::TIMESTAMP::date = s.date and
            ((r.start_t::TIMESTAMP::TIME, r.end_t::TIMESTAMP::TIME ) OVERLAPS (s.start_t, s.end_t)));

            // change to the format....must use ' not " to express
            select start_t::TIMESTAMP::date as date,
            case EXTRACT(ISODOW FROM start_t)
                    when 1 then 'Monday'
                    when 2 then 'Tuesday'
                    when 3 then 'Wednesday'
                    when 4 then 'Thursday'
                    when 5 then 'Friday'
                    when 6 then 'Saturday'
                    when 7 then 'Sunday'
                    else null
                endend::varchar(50) as weekday
                , start_t::TIMESTAMP::time as start_time, end_t::TIMESTAMP::time as end_time
            from available_range;




            // generate first if needed
            // generate the first day !!!
            SELECT MIN(dt) AS first_date
            FROM generate_series('2023-05-01'::date, '2023-05-31'::date, '1 day') AS dt
            WHERE EXTRACT(ISODOW FROM dt) = 2;

*/


/*
            // --> single date....generate_series, automatically generate several row
            // still very hard to convert to the date then merge with review....still need to use join
            select generate_series('2023-05-01'::date, '2023-05-01'::date + INTERVAL '70 days', '1 day') as date,
            start_t, end_t from weekly where
            EXTRACT(ISODOW FROM date) = weekday;


            SELECT start_t, end_t,
            GENERATE_SERIES(start_date, end_date, '1 day') AS date
            FROM (
            SELECT start_t, end_t,
                    GENERATE_SERIES(
                    '2023-05-01'::date,
                    '2023-05-31'::date,
                    '1 day'
                    ) AS start_date
            FROM weekly
            WHERE weekday IS NOT NULL
            ) subquery
            WHERE EXTRACT(ISODOW FROM start_date) = weekday;
            */


            /*
            difference left join...even if not match also return
// 1770
select r.start_t, r.end_t from all_range r INNER JOIN weekly w on not( EXTRACT(ISODOW FROM r.start_t) = w.weekday and ((r.start_t::TIMESTAMP::TIME, r.end_t::TIMESTAMP::TIME ) OVERLAPS (w.start_t, w.end_t))) order by r.start_t asc, r.end_t asc;

// ERROR:  FULL JOIN is only supported with merge-joinable or hash-joinable join conditions
select r.start_t, r.end_t from all_range r Full JOIN weekly w on not( EXTRACT(ISODOW FROM r.start_t) = w.weekday and ((r.start_t::TIMESTAMP::TIME, r.end_t::TIMESTAMP::TIME ) OVERLAPS (w.start_t, w.end_t))) order by r.start_t asc, r.end_t asc;

// 1770
select r.start_t, r.end_t from all_range r left JOIN weekly w on not( EXTRACT(ISODOW FROM r.start_t) = w.weekday and ((r.start_t::TIMESTAMP::TIME, r.end_t::TIMESTAMP::TIME ) OVERLAPS (w.start_t, w.end_t))) order by r.start_t asc, r.end_t asc;

// 1770 = 600*3 -30
select r.start_t, r.end_t from all_range r right JOIN weekly w on not( EXTRACT(ISODOW FROM r.start_t) = w.weekday and ((r.start_t::TIMESTAMP::TIME, r.end_t::TIMESTAMP::TIME ) OVERLAPS (w.start_t, w.end_t))) order by r.start_t asc, r.end_t asc;

// we need to use where not exist to eliminate ... not pair cross
// 570 = 600 -30
            select r.start_t, r.end_t from all_range r where not exists (select 1 from weekly w where
            EXTRACT(ISODOW FROM r.start_t) = w.weekday and
            ((r.start_t::TIMESTAMP::TIME, r.end_t::TIMESTAMP::TIME ) OVERLAPS (w.start_t, w.end_t)))
            order by r.start_t asc, r.end_t asc;
            */


/*
            // where exist can't use the inside table !!!!! in this case, we have to use  join.... for this case of specific equal, we need to use on, not where
            // use distinct to eleminate identical rows
            "select no.section_id, no.s_year, yes.section_id, yes.s_year from not_enrolled_weekly no where exists"+
            "(select 1 from enrolled_weekly yes where yes.m_day = no.m_day and "+
            "((yes.start_t, yes.end_t) OVERLAPS (no.start_t, no.end_t)));";
            */
