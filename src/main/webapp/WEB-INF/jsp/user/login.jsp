<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<jsp:include page="../common/common-include.jsp"></jsp:include>
<title>登录</title>
</head>
<body style="background-color:#eee">


<div class="container" style="margin-top:50px">

    <div class="row">
        <div class="col-sm-6 col-sm-offset-3 form-box">
        	<div class="form-top">
        		<div class="form-top-left">
            		<p>Enter your username and password to log on:</p>
        		</div>
        		<div class="form-top-right">
        			<i class="fa fa-key"></i>
        		</div>
            </div>
            <div class="form-bottom">
       <form role="form" action="${pageContext.request.contextPath}/service/user/dologin" method="post" class="login-form">
       		<div class="form-group 
       			<c:if test="${!empty err_msg }">
					has-error
				</c:if>
				">
				
	       		<label class="sr-only" for="userName">Username</label>
	           	<input type="text" name="userName" placeholder="Username..." class="form-control" id="form-username" value="${userName }">
	           	<c:if test="${!empty err_msg }">
					<label class="control-label">${err_msg }</label>
				</c:if>
           </div>
           <div class="form-group">
	           	<label class="sr-only" for="password">Password</label>
	           	<input type="password" name="password" placeholder="Password..." class="form-control" id="form-password">
           </div>
           <button type="submit" class="btn btn-orange">Sign in!</button>
       </form>
      </div>
        </div>
    </div>

</div>


</body>
</html>