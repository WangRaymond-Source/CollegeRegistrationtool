<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
{
  <% 
    // for initialization
    // why this can be written in funciton ??
    Connection conn=null;
    try{
        DriverManager.registerDriver(new org.postgresql.Driver());
        conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
        //System.out.println("connected");

        // connection.close(); // move to the end
    }catch(Exception e){
        // xx = "fail";
        out.println("fail to connect to database");
        // myout.println();
        e.printStackTrace();
    }
  %>

  <%!
  public String json_reponse(String name,String value){
    return "\""+name+"\":\""+value+"\",";
  }

  public String json_reponse(String name,String[] value){
    String res = "\""+name+"\":\"{";
    for(int i=0;i<value.length;i++)
      res += "\"" + value[i] +"\",";
    res += "}\",";
    return res;
  }
  %>


    <%@ page language="java" import="java.sql.*" %>
    <%@ page language="java" import="net.FTM" %>
    <%@ page import="java.util.Arrays" %>
    <%

    // get or post method not affect the get method
    // but only the send() message type affect it....getParameter(=), json(json)
    if (request.getMethod().equals("POST") || request.getMethod().equals("GET")) // use get to debug!!!
        if (request.getParameterMap().containsKey("table_name")){
          String table_name = request.getParameter("table_name");
          String action_type = request.getParameter("type");
          out.println(json_reponse("table_name",table_name));
          out.println(json_reponse("type", action_type));
          // get related information....schema
          String[][] schema_type = FTM.tablename_schema(conn, table_name); // null table_name...make hundreds of null
          String[] schema = schema_type[0] ; // 0-name, 1-type


          try{
            // get data
            String[] data_origin = new String[schema.length];
            int t=0; // can set in int i=0,t=0... take as declare 2 int
            for (int i=0;i<data_origin.length;i++)
              if (request.getParameterMap().containsKey(schema[i])){
                data_origin[t] = request.getParameter(schema[i]);
                out.println(json_reponse(schema[t], data_origin[t]));
                // write down the matched column...unmatched be overwritten
                schema_type[0][t] = schema_type[0][i];
                schema_type[1][t] = schema_type[1][i];
                // advance
                t++;
              }
            out.println(json_reponse("t#", String.valueOf(t)));
            // remove unmatched column...like for meeting_id.. auto incremental identity
            // out.println(json_reponse("schema",schema_type[0]));
            schema_type[0] = Arrays.copyOfRange(schema_type[0], 0, t);
            schema_type[1] = Arrays.copyOfRange(schema_type[1], 0, t);
            schema = schema_type[0]; // need to reassign..otherwise, still use old string[]
            data_origin = Arrays.copyOfRange(data_origin, 0, t);
            // out.println(json_reponse("schema_after",schema_type[0]));

            // covert to sql data
            String[][] data = FTM.string_java_sql(new String[][]{data_origin}, schema, schema_type);
            

            // process the data
            boolean ifsuccess = false;
            String[] res = null;
            if (action_type.equals("insert")){
              res = FTM.tablename_insert(conn.createStatement(),table_name, schema,data);
              // localhost:8080/tritonlink/FTMweb_action.jsp?table_name=faculty&type=insert&name=Christopher&department=CSE&title=Professor
            } else if (action_type.equals("update")){
              res = FTM.tablename_update(conn,table_name, schema,data);
              // localhost:8080/tritonlink/FTMweb_action.jsp?table_name=faculty&type=update&name=Christopher88&department=ECE&title=Professor
            } else if (action_type.equals("delete")){
              res = FTM.tablename_delete(conn,table_name, schema,data);
              // localhost:8080/tritonlink/FTMweb_action.jsp?table_name=faculty&type=delete&name=Christopher8&department=ECE&title=Professor
            } else {
              out.print(json_reponse("fail","unhandled action type "+action_type));
              throw new Exception("unhandled action type "+action_type);
            }


            if (res[0].equals("T"))
              ifsuccess = true;
            else if(res[0].equals("F"))
              ifsuccess = false;
            out.println(json_reponse("sql_cmd",res[1]));
            out.println(json_reponse("ifsuccess",String.valueOf(ifsuccess)));
            if (!ifsuccess){
              out.println(json_reponse("sql_error",res[2].replaceAll("\n", "   "))); // can't have '\n'
              /*...array can't directly print out("" not compact with json), for debug
              out.println(json_reponse("origin_data",data_origin));
              out.println(json_reponse("schema",schema));
              out.println(json_reponse("type",schema_type[1]));
              out.println(json_reponse("data",data[1]));
              */
              out.print("\"failure_detail\": \"(java)  "); // \t ... bad control character by json.parse in js
              /*
              for(int i=0;i<schema_type[0].length;i++)
                out.print(schema_type[0][i]+"\t");
              for(int i=0;i<data_origin.length;i++)
                out.print(data_origin[i]+"\t");
              if (data==null)
                out.print("data is null");
              */
              for(int i=0;i<data_origin.length;i++)
                out.print(data_origin[i]+"   ");
              out.println("\",");
            }

          } catch(Exception e){
            // xx = "fail";
            out.println("(jsp)");
            // myout.println();
            out.println("\",");
            e.printStackTrace();
          }
      } else if(request.getParameterMap().containsKey("special")){
        String special_action = request.getParameter("special");
        String[] res = null;
        boolean ifsuccess = false;
        try {
          // print the default path
          String realPath = request.getServletContext().getRealPath("/");
          out.println(json_reponse("Real Path ", realPath)); // take /var/lib/tomcat9/webapps/ROOT/ as default path
          // http://localhost:8080/tritonlink/FTMweb_action.jsp?special=add_contraint_trigger
          // http://localhost:8080/CSE132B_Project/Dynamic/FTMweb_action.jsp?special=add_contraint_trigger
          // when it run here, must take the path here as default....must use absolute path to avoid not found
          if(special_action.equals("add_contraint_trigger")){
            res = FTM.path_execute_sql("/Users/raymondwang/apache-tomcat-9.0.71/webapps/ROOT/CSE132B_Project/Dynamic/trigger_constraint.sql",conn.createStatement());
          }
          if (res[0].equals("T"))
            ifsuccess = true;
          else if(res[0].equals("F"))
            ifsuccess = false;
          out.println(json_reponse("ifsuccess",String.valueOf(ifsuccess)));
          if (!ifsuccess){
            out.println(json_reponse("sql_cmd",res[1]));
            out.println(json_reponse("sql_error",res[2].replaceAll("\n", "   "))); // can't have '\n'
            /*...array can't directly print out("" not compact with json), for debug
            out.println(json_reponse("origin_data",data_origin));
            out.println(json_reponse("schema",schema));
            out.println(json_reponse("type",schema_type[1]));
            out.println(json_reponse("data",data[1]));
            */
            out.print("\"failure_detail\": \"(java)  "); // \t ... bad control character by json.parse in js
            /*
            for(int i=0;i<schema_type[0].length;i++)
              out.print(schema_type[0][i]+"\t");
            for(int i=0;i<data_origin.length;i++)
              out.print(data_origin[i]+"\t");
            if (data==null)
              out.print("data is null");
            */
          }

        } catch(Exception e){
          // xx = "fail";
          out.println("(jsp)");
          // myout.println();
          out.println("\",");
          e.printStackTrace();
        }
      }

    %>
        

  <%
    try{
      conn.close();
      out.println("\"closed\":\"true\"");  
      //"'closed':true" ... must use double-quoted property
      // last one can't use json_response, no comma(,)
    }catch(Exception e){
        out.println("fail with close connection");
        // out.println(e.printStackTrace());
        e.printStackTrace();
    }
    
  %>

}
