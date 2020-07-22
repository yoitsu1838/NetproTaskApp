<%@ page import="java.util.*,java.sql.*" contentType="text/html; charset=UTF-8"%>
<%! String resultStatus; %>
<%! String exceptionMsg; %>
<%! int resultCode; %>
<%
//Todo SQLインジェクション対策
//Todo データベースの正規化
 request.setCharacterEncoding("UTF-8");
 String name = request.getParameter("name");
 String category = request.getParameter("category");
 String addCategory = request.getParameter("addCategory");
 if(category.equals("addCat")){
	 category = addCategory;
 }
 String deadline = request.getParameter("deadline");
 String done = "false";
 String hide = "false";

  try {


  // PostgreSQL JDBC 接続

  String driverClassName = "org.postgresql.Driver";
  String url = "jdbc:postgresql://localhost/task";
  String user = "dbpuser"; // ここはユーザ名
  String password = "hogehoge"; // ここはパスワード
  Connection connection;
  Statement statement;
  ResultSet resultSet;
  String sql = "INSERT INTO task (taskName,category,deadline,done,hide)  VALUES ('" + name + "', '" +
		   category + "', '" + deadline + "', '" + done + "', '" + hide + "')";

  // PostgreSQL JDBC ドライバロード
  Class.forName(driverClassName);

  connection = DriverManager.getConnection(url, user, password);

  if(name!=null && category != null && deadline != null){
  // PostgreSQL JDBC 問い合わせ SQL 作成
  statement = connection.createStatement();


  // PostgreSQL JDBC 更新

	  int ans = statement.executeUpdate(sql);

	  if (ans > 0) {
		  resultCode = 0;
		  resultStatus = "タスクを登録しました";
	  } else {
		  resultCode = 1;
	      out.println("登録に失敗しました");
	    }





  // PostgreSQL JDBC ステートメントクローズ
  statement.close();


  } else {
	  resultCode = 2;
	  resultStatus = "送信されたデータが不正もしくは空です。";
  }
  // PostgreSQL JDBC 接続クローズ
  connection.close();



 } catch (Exception e) {
  // エラー処理
  //out.println(e);
	 exceptionMsg = e.toString();
 }
 %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0" >

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
    <li class="nav-item hoverlink active"><a class="nav-link"
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


 <!--Main layout-->
 <main class="mt-5"> <!--Main container-->
 <div class="container">
  <!--Grid row-->
  <div class="row">

   <!--Grid column-->
   <div class="col-lg-12 col-md-12 mb-4">
    <h2>タスクの登録処理を行いました</h2>
    <hr>
	<div class="alert alert-<%
	if(resultCode==0){out.print("success");}else if(resultCode==1){out.print("danger");}else if(resultCode==2){out.print("danger");}else{out.print("secondary");}
	%>" role="alert">
	  <h4 class="alert-heading"><% out.print(resultStatus); %></h4>
	  <p><% if(exceptionMsg!=null)out.print(exceptionMsg); %></p>
	  <hr>
	  <p class="mb-0">再度タスクを追加する場合は<a href="http://localhost:8080/NetproTaskApp/add.jsp">ここ</a>をクリックしてください。</p>
	</div>
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