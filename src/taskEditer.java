

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class taskEditer
 */
@WebServlet("/taskEditer")
public class taskEditer extends HttpServlet {
    String driverClassName = "org.postgresql.Driver";
    String url = "jdbc:postgresql://localhost/task";
    String user = "dbpuser";
    String password = "hogehoge";
    Connection connection;
    Statement statement;
    ResultSet resultSet;
    String cid;

    String taskid;
    String taskName;
    String category;
    String deadline;
    String done;
    String hide;

    PreparedStatement prepStmt_I;
    PreparedStatement prepStmt_U;
    PreparedStatement prepStmt_U_status;
    PreparedStatement prepStmt_D;

    String sql = "SELECT * From task";
    String strPrepSQL_U = "UPDATE task SET taskname = ?,  category= ?, deadline = ? WHERE taskid = ?";
    String strPrepSQL_U_status = "UPDATE task SET done = ? WHERE taskid = ?";
    String strPrepSQL_D = "DELETE FROM task WHERE taskid = ?";

    public void doGet(HttpServletRequest request,
    HttpServletResponse response) throws ServletException {
        sortCommand(request, response);
    }

    public void doPost(HttpServletRequest request,
    HttpServletResponse response) throws ServletException {
        sortCommand(request, response);
    }


    public void sortCommand(HttpServletRequest request,
    	    HttpServletResponse response) {
    	        try {
    	            Class.forName(driverClassName);
    	            connection = DriverManager.getConnection(url, user, password);

    	            cid = request.getParameter("cid");
    	            taskid = request.getParameter("taskid");

    	            if (cid.equals("show")) {//特定のタスクを表示する
    	              show(response);
    		    } else if (cid.equals("edit")) {
    	              getAction(request, response);
    		    } else if (cid.equals("update")) {
    	              update(request, response);
    		    } else if (cid.equals("delete")) {
    	              delete(request, response);
    		    } else if (cid.equals("done")) {//各々の処理が終わった時のリダイレクト先
    		    	  changeStatus(request, response);
    		    } else {//指定なし
    	              show(response);
    		    }
    	            connection.close();
    	        } catch (Exception e) {
    	            printError(response, e);
    	        }
    	    }

    public void show(HttpServletResponse response) {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery(sql);

            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" ><title>DATABASE_CONTROL</title></head><body>");

            out.println("<h2>タスクの編集・削除</h2>");

            String table = "<table width=\"100%\" border=3><tr style=\"background-color:#c0c0c0\"><td>タスク名</td><td>カテゴリ</td><td>締切</td><td>状態</td></tr>";

            String status="";
            while (resultSet.next()) {
            	if(taskid.equals(resultSet.getString("taskid"))) {
	                taskName = resultSet.getString("taskname");
	                category = resultSet.getString("category");
	                deadline = resultSet.getString("deadline");
	                status = resultSet.getString("done");
	                if(status.equals("t")) {
	                	done = "完了";
	                }else {
	                	done = "未完";
	                }
	                hide = resultSet.getString("hide");


	                table += "<tr><td>"+ taskName + "</td><td>"
	                        + category + "</td><td>"
	                        + deadline + "</td><td>"
	                        + done + "</td></tr>";
            	}


            }

            table += "</table>";
            out.println(table);
            out.println("<br><a href=\"./taskEditer?cid=edit&taskid="+ taskid + "\">[変更]</a>");
            out.println("　<a href=\"./taskEditer?cid=done&taskid="+ taskid + "&status="+ status + " \">[完了済み・未完了]</a>");
            out.println("　<a href=\"#\"  onClick=\"del()\" \">[削除]</a>");
            out.println("<script language=\"javascript\">");
            out.println("<!--");
            out.println("function del() {");
            out.println(" if (confirm(\"削除しますか？\")) { ");
            out.println("    location.href=\"./taskEditer?cid=delete&taskid=" + taskid + "\";");
            out.println(" }");
            out.println("}");
            out.println("// -->");
            out.println("</script>");
            out.println("</body></html>");

            out.close();
            resultSet.close();
            statement.close();
        } catch (Exception e) {
            printError(response, e);
        }

    }

    public void getAction(HttpServletRequest request,
    HttpServletResponse response) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (request.getParameter("taskid") == null) {
            out.println("<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" ><title>DATABASE_CONTROL</title></head><body>");
            out.println("<p>該当データがありません。</p>");

            out.println("</body></html>");
        } else {
            statement = connection.createStatement();
            resultSet = statement.executeQuery(
            "SELECT * FROM task WHERE taskid = " + request.getParameter("taskid"));

            resultSet.next();


            taskid = resultSet.getString("taskid");
            taskName = resultSet.getString("taskname");
            category = resultSet.getString("category");
            deadline = resultSet.getString("deadline");


            out.println("<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" ><title>DATABASE_CONTROL</title>");
            out.println("<script language=\"javascript\">");
            out.println("<!--");
            out.println("function del() {");
            out.println(" if (confirm(\"削除しますか？\")) { ");
            out.println("    location.href=\"./taskEditer?cid=delete&taskid=" + taskid + "\";");
            out.println(" }");
            out.println("}");
            out.println("// -->");
            out.println("</script>");
            out.println("</head><body>");
            out.println("<h2>変更 / 削除</h2>");
            out.println("<form method=\"POST\" action=\"./taskEditer?cid=update&taskid="+taskid+"\">");
            out.println("<table border=\"0\">");
            out.println("<tr><td>名前</td><td><input type=\"text\" name=\"taskname\" value=\"" + taskName + "\"</td></tr>");
            out.println("<tr><td>カテゴリー</td><td><input type=\"text\" name=\"category\" value=\"" + category + "\"</td></tr>");
            out.println("<tr><td>電話</td><td><input type=\"text\" name=\"deadline\" value=\"" + deadline + "\"</td></tr>");
            out.println("</table>");
            out.println("<input type=\"submit\" value=\"変更\">");
            out.println("<input type=\"button\" value=\"削除\" onClick=\"del()\">");
            out.println("</form>");
            out.println("</body></html>");


            resultSet.close();
            statement.close();
        }
    }


    public void update(HttpServletRequest request,
    HttpServletResponse response) throws Exception {
        try {

        	taskid =request.getParameter("taskid");
            taskName = request.getParameter("taskname");
            category = request.getParameter("category");
            deadline = request.getParameter("deadline");
            Date date = Date.valueOf(deadline);
            done = request.getParameter("done");
            hide = request.getParameter("hide");

            prepStmt_U = connection.prepareStatement(strPrepSQL_U);

            prepStmt_U.setString(1, new String(taskName.getBytes ("8859_1"), "UTF-8"));
            prepStmt_U.setString(2, new String(category.getBytes ("8859_1"), "UTF-8"));
            prepStmt_U.setDate(3, date);
            prepStmt_U.setInt(4, Integer.parseInt(request.getParameter("taskid")));

            if (!taskid.equals("") && !taskid.equals("0")) {
                prepStmt_U.executeUpdate();
                finish(response);
            } else {
              showErrorMsg(response);
            }

        } catch (SQLException e) {
        	printError(response, e);
        	//showErrorMsg(response);
        }
    }

    public void delete(HttpServletRequest request,
    HttpServletResponse response) throws Exception {
        prepStmt_D = connection.prepareStatement(strPrepSQL_D);
        prepStmt_D.setInt(1, Integer.parseInt(request.getParameter("taskid")));
        prepStmt_D.executeUpdate();

        finish(response);
    }

    public void changeStatus(HttpServletRequest request,
    HttpServletResponse response) throws Exception {
	    try {
	    	taskid =request.getParameter("taskid");
	    	boolean status = false;
	    	if(request.getParameter("status").equals("t")) {
	    		status = true;
	    	}else if(request.getParameter("status").equals("f")) {
	    		status = false;
	    	}

	    	if(status) {
	    		status = false;
	    	}else {
	    		status = true;
	    	}

	    	 prepStmt_U_status = connection.prepareStatement(strPrepSQL_U_status);

	         prepStmt_U_status.setBoolean(1, status);
	         prepStmt_U_status.setInt(2, Integer.parseInt(request.getParameter("taskid")));

	         if (!taskid.equals("") && !taskid.equals("0")) {
	             prepStmt_U_status.executeUpdate();
	             finish(response);
	         } else {
	           showErrorMsg(response);
	         }

	    } catch (SQLException e) {
	    	printError(response, e);
	    	//showErrorMsg(response);
	    }

    }

    public void finish(HttpServletResponse response) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" ><title>DATABASE_CONTROL</title></head> <body>");
        out.println("<p>処理を完了しました。</p>");

        out.println("</body></html>");

        out.close();
    }


    public void showErrorMsg(HttpServletResponse response) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" ><title>DATABASE_CONTROL</title></head> <body>");
        out.println("<h2>エラーが発生しました。</h2>");
        out.println("<br><br>");
        out.println("</body></html>");

        out.close();
    }

    public void printError(HttpServletResponse response, Exception e) {
	try {
	    response.setContentType("text/html; charset=UTF-8");
	    PrintWriter out = response.getWriter();
	    out.println("<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" ><title>DATABASE_CONTROL</title></head><body>");
	    out.println(e.getMessage()+"<br>");
	    out.println("</body></html>");
	    out.close();
	} catch (Exception er) {
	    er.printStackTrace();
	}
    }


}
