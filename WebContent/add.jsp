<%@ page import="java.sql.*" language="java"
 contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>タスクの追加 - タスク管理</title>
<!-- Font Awesome -->
<link rel="stylesheet"
 href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
<!-- Google Fonts -->
<link rel="stylesheet"
 href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap">
<!-- Bootstrap core CSS -->
<link
 href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.4.1/css/bootstrap.min.css"
 rel="stylesheet">
<!-- Material Design Bootstrap -->
<link
 href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.18.0/css/mdb.min.css"
 rel="stylesheet">

<!--  for date picker -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-material-datetimepicker/2.7.1/css/bootstrap-material-datetimepicker.min.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">

 <link href="css/style.css" rel="stylesheet">

</head>
<body>
 <!--Main Navigation-->
 <header>
 <!--Navbar-->
 <nav class="navbar navbar-expand-lg navbar-dark unique-color">
 <!-- Additional container -->
 <div class="container">

  <!-- Navbar brand -->
  <a class="navbar-brand" href="index.jsp">タスク管理</a>

  <!-- Collapse button -->
  <div class="animated-icon">
   <button class="navbar-toggler cross-button" type="button"
    data-toggle="collapse" data-target="#basicExampleNav"
    aria-controls="basicExampleNav" aria-expanded="false"
    aria-label="Toggle navigation">
    <span></span><span></span><span></span><span></span>
   </button>
  </div>

  <!-- Collapsible content -->
  <div class="collapse navbar-collapse" id="basicExampleNav">

   <!-- Links -->
   <!-- InstanceBeginEditable name="navLink" -->
   <ul class="navbar-nav mr-auto">
    <li class="nav-item hoverlink"><a class="nav-link"
     href="index.jsp">Home</a></li>
    <li class="nav-item active hoverlink"><a class="nav-link"
     href="add.jsp">タスク追加 <span class="sr-only">(current)</span></a></li>
    <li class="nav-item hoverlink"><a class="nav-link"
     href="category.jsp">カテゴリー</a></li>

   </ul>
   <!-- InstanceEndEditable -->
   <!-- Links -->

  </div>
  <!-- Collapsible content -->

 </div>
 <!-- Additional container -->
 </nav>

 <!--/.Navbar-->
  </header>
 <!--// Main Navigation-->

 <%!String todayTask;%>
 <%!ArrayList<String> categorys = new ArrayList<String>();%>

 <%
  try {

  //今日締切のタスク関係
  Date date = new Date();
  DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
  String todayDate = dateFormat.format(date);
  // PostgreSQL JDBC 接続

  String driverClassName = "org.postgresql.Driver";
  String url = "jdbc:postgresql://localhost/task";
  String user = "dbpuser"; // ここはユーザ名
  String password = "hogehoge"; // ここはパスワード
  Connection connection;
  Statement statement;
  ResultSet resultSet;
  String sql = "SELECT DISTINCT category FROM task";

  // PostgreSQL JDBC ドライバロード
  Class.forName(driverClassName);

  connection = DriverManager.getConnection(url, user, password);

  // PostgreSQL JDBC 問い合わせ SQL 作成
  statement = connection.createStatement();

  // PostgreSQL JDBC レコードセットオープン
  resultSet = statement.executeQuery(sql);

  // PostgreSQL JDBC レコードセットリード
  while (resultSet.next()) {
   categorys.add(resultSet.getString("category"));
  }


  // PostgreSQL JDBC レコードセットクローズ
  resultSet.close();

  // PostgreSQL JDBC ステートメントクローズ
  statement.close();

  // PostgreSQL JDBC 接続クローズ
  connection.close();

 } catch (Exception e) {
  // エラー処理
  out.println(e);
 }
 %>


 <!--Main layout-->
 <main class="mt-5"> <!--Main container-->
 <div class="container">
  <!--Grid row-->
  <div class="row">

   <!--Grid column-->
   <div class="col-lg-12 col-md-12 mb-4">
    <h2>タスクの追加</h2>
    <hr>
    <p>このページでは，タスクの追加を行います。</p>
		<form method="post" class="text-center border border-light p-5" action="./taskinsert.jsp">



		    <!-- タスク名 -->
		    <input type="text" class="form-control mb-4" name="name" placeholder="タスク名" maxlength="120"  required="required">

		    <!--  カテゴリー -->
		    <label>カテゴリー</label>
		    <select class="browser-default custom-select mb-4" name="category"  required="required">
		        <%
		        for(String category : categorys){

			        out.print("<option value=\""+category+"\">" + category + "</option>" );
		        }
		        categorys.clear();
		        %>

		    </select>

		    <!-- 締切 -->
		    <div class="date"><input type="text" id="picker" class="form-control mb-4" name="deadline" placeholder="クリックして選択"  required="required"></div>



		    <!-- submit -->
		    <button class="btn btn-info btn-block" type="submit">タスクを追加</button>


		</form>

   </div>
   <!--Grid column-->
  </div>
  <!--Grid row-->


 </div>
 <!--Main container--> </main>
 <!--Main layout-->



 <!-- Footer -->
 <footer class="page-footer font-small indigo pt-4 mt-4 unique-color">


 <!-- Copyright -->
 <div class="footer-copyright text-center py-3">
  © 2020 <a href="#" target="_blank"> NETPRO</a>
 </div>
 <!-- Copyright --> </footer>
 <!-- //Footer -->

 <!-- JQuery -->
 <script
  src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
 <!-- Bootstrap tooltips -->
 <script
  src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.4/umd/popper.min.js"></script>
 <!-- Bootstrap core JavaScript -->
 <script
  src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.4.1/js/bootstrap.min.js"></script>
 <!-- MDB core JavaScript -->
 <script
  src="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.18.0/js/mdb.min.js"></script>

 <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.20.1/moment.min.js"></script>
 <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-material-datetimepicker/2.7.1/js/bootstrap-material-datetimepicker.min.js"></script>


  <script type="text/javascript">

/*nav_button*/
$(document).ready(function () {

    $('.cross-button').on('click', function () {

        $('.animated-icon').toggleClass('open');
    });


    //2.2
    $(function(){
    	$("#picker").bootstrapMaterialDatePicker({
    	weekStart:0,
    	format:"YYYY-MM-DD",
    	time:false
    	});
    });
});

</script>

</body>
</html>