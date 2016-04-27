<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<jsp:include page="../common/common-include.jsp"></jsp:include>
<title>创建菜单</title>
</head>
<body>
	<div>
		<div class="container">
			<h1>创建菜单</h1>
		</div>
	</div>
	<div class="container" >
		<form action="domenucreate" method="POST" class="form-horizontal">
		
			<div class="form-group">
				<label for="menu" class="col-sm-2 control-label">config json</label>
				<div class="col-sm-10">
					<textarea class="form-control" id="menu" name="menu" style="min-height:750px">${menu }</textarea>
				</div>
			</div>
			<button type="submit" class="btn btn-default">submit</button>
		</form>
	</div>
</body>
</html>