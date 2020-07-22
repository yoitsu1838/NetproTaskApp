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
<title>タスク管理</title>
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
<style type="text/css">
main {
 min-height: calc(100vh - 130px);
}
/* toggleAnimation*/
.animated-icon {
    width: 30px;
    height: 20px;
    position: relative;
    margin: 0px;
    -webkit-transform: rotate(0deg);
    -moz-transform: rotate(0deg);
    -o-transform: rotate(0deg);
    transform: rotate(0deg);
    -webkit-transition: .5s ease-in-out;
    -moz-transition: .5s ease-in-out;
    -o-transition: .5s ease-in-out;
    transition: .5s ease-in-out;
    cursor: pointer;
}
.animated-icon span {
    display: block;
    position: absolute;
    height: 3px;
    width: 100%;
    border-radius: 9px;
    opacity: 1;
    left: 0;
    -webkit-transform: rotate(0deg);
    -moz-transform: rotate(0deg);
    -o-transform: rotate(0deg);
    transform: rotate(0deg);
    -webkit-transition: .25s ease-in-out;
    -moz-transition: .25s ease-in-out;
    -o-transition: .25s ease-in-out;
    transition: .25s ease-in-out;
}
.animated-icon span {
    background: #e3f2fd;
}
.animated-icon span:nth-child(1) {
    top: 0px;
}
.animated-icon span:nth-child(2), .animated-icon span:nth-child(3) {
    top: 10px;
}
.animated-icon span:nth-child(4) {
    top: 20px;
}
.animated-icon.open span:nth-child(1) {
    top: 11px;
    width: 0%;
    left: 50%;
}
.animated-icon.open span:nth-child(2) {
    -webkit-transform: rotate(45deg);
    -moz-transform: rotate(45deg);
    -o-transform: rotate(45deg);
    transform: rotate(45deg);
}
.animated-icon.open span:nth-child(3) {
    -webkit-transform: rotate(-45deg);
    -moz-transform: rotate(-45deg);
    -o-transform: rotate(-45deg);
    transform: rotate(-45deg);
}
.animated-icon.open span:nth-child(4) {
    top: 11px;
    width: 0%;
    left: 50%;
}
/* //toggleAnimation*/
/* video iframe */
.video {
    position: relative;
    width: 100%;
    height: 0;
    padding-top: 75%;
}
.video iframe {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
}
/* nav hovercolor*/
.hoverlink a {
    position: relative;
    display: inline-block;
    transition: .3s;
}
.hoverlink a::before, .hoverlink a::after {
    position: absolute;
    content: '';
    width: 0;
    height: 1px;
    background-color: #1C2331;
    transition: .3s;
}
.hoverlink a::before {
    top: 0;
    left: 0;
}
.hoverlink a::after {
    bottom: 0;
    right: 0;
}
.hoverlink a:hover::before, .hoverlink a:hover::after {
    width: 100%;
}
</style>
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
    <li class="nav-item active hoverlink"><a class="nav-link"
     href="index.jsp">Home <span class="sr-only">(current)</span></a></li>
    <li class="nav-item hoverlink"><a class="nav-link"
     href="add.jsp">タスク追加</a></li>
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

 <%!String noTodayTask;%>
 <%!ArrayList<String> todayTask = new ArrayList<String>();%>
 <%!ArrayList<String> taskName = new ArrayList<String>();%>
 <%!ArrayList<String> category = new ArrayList<String>();%>
 <%!ArrayList<String> deadline = new ArrayList<String>();%>
 <%!ArrayList<String> done = new ArrayList<String>();%>
 <%!ArrayList<String> hide = new ArrayList<String>();%>
 <%
  try {

  //今日締切のタスク関係
  Date date = new Date();
  DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
  String todayDate = dateFormat.format(date);
  noTodayTask = "<span class=\"todayTask none\">今日締め切りのタスクはありません。</span>";
  // PostgreSQL JDBC 接続

  String driverClassName = "org.postgresql.Driver";
  String url = "jdbc:postgresql://localhost/task";
  String user = "dbpuser"; // ここはユーザ名
  String password = "hogehoge"; // ここはパスワード
  Connection connection;
  Statement statement;
  ResultSet resultSet;
  String sql = "SELECT * FROM task ORDER BY deadline ASC";

  // PostgreSQL JDBC ドライバロード
  Class.forName(driverClassName);

  connection = DriverManager.getConnection(url, user, password);

  // PostgreSQL JDBC 問い合わせ SQL 作成
  statement = connection.createStatement();

  // PostgreSQL JDBC レコードセットオープン
  resultSet = statement.executeQuery(sql);

  // PostgreSQL JDBC レコードセットリード
  while (resultSet.next()) {
   taskName.add(resultSet.getString("taskName"));
   category.add(resultSet.getString("category"));
   deadline.add(resultSet.getString("deadline"));
   done.add(resultSet.getString("done"));
   hide.add(resultSet.getString("hide"));

   if (resultSet.getString("deadline").equals(todayDate)) {
  	todayTask.add(resultSet.getString("taskName"));
   }
  }
  if(todayTask.size()==0){
	  todayTask.add(noTodayTask);
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
    <h2>今日〆切タスク</h2>
    <hr>
    <p>
     <%for(String todaytask:todayTask){
      out.print(todaytask + "<br>");
     }
     %>
    </p>
   </div>
   <!--Grid column-->
  </div>
  <!--Grid row-->
  <!--Grid row-->
  <div class="row">

   <!--Grid column-->
   <div class="col-lg-12 col-md-12 mb-4">
   <br>
    <h2>タスク一覧</h2>
    <hr>
   </div>
   <!--Grid column-->
  </div>
  <!--Grid row-->

  <!--Grid row-->
  <div class="row">
   <!--繰り返し単位-->
   <%
    int index = 0;
   for (String name : taskName) {
	   if(done.get(index).equals("f")){//未達成タスク
    out.print("<div class=\"col-lg-4 col-md-12 mb-4\"><!--Card--><div class=\"card\"><!--Card content-->" +
    "<div class=\"card-body\"><!--Title--><h4 class=\"card-title\">" + name + "</h4><!--Text-->" +
    "<p class=\"card-text\"><span class=\"category\">カテゴリー：" + category.get(index) + "</span><br>" +
    "<span class=\"deadline\">締切：" + deadline.get(index) + "</span></p>" +
    "<a href=\"committee.html\" class=\"btn btn-sm btn-indigo\">変更・削除</a></div></div><!--/.Card--></div>");
	   }
    index++;
   }
   %>
   <!--//繰り返し単位-->
  </div>
  <!--Grid row-->


  <!--Grid row-->
  <div class="row">
   <!--Grid column-->
   <div class="col-lg-12 col-md-12 mb-4">
   <br>
    <h2>完了済タスク</h2>
    <hr>
   </div>
   <!--Grid column-->
  </div>
  <!--Grid row-->

  <!--Grid row-->
  <div class="row">
   <!--繰り返し単位-->
   <%
   index = 0;
   for (String name : taskName) {
	   if(done.get(index).equals("t")){//完了済タスク
    out.print("<div class=\"col-lg-4 col-md-12 mb-4\"><!--Card--><div class=\"card\"><!--Card content-->" +
    "<div class=\"card-body\"><!--Title--><h4 class=\"card-title\">" + name + "</h4><!--Text-->" +
    "<p class=\"card-text\"><span class=\"category\">カテゴリー：" + category.get(index) + "</span><br>" +
    "<span class=\"deadline\">締切：" + deadline.get(index) + "</span></p>" +
    "<a href=\"committee.html\" class=\"btn btn-sm btn-indigo\">変更・削除</a></div></div><!--/.Card--></div>");
	   }
    index++;
   }
   taskName.clear();
   %>
   <!--//繰り返し単位-->
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
 <script type="text/javascript">

/*nav_button*/
$(document).ready(function () {

    $('.cross-button').on('click', function () {

        $('.animated-icon').toggleClass('open');
    });

});

</script>

</body>
</html>