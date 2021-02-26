<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 상대 경로를 이용하여, header 포함시키기 -->
<!-- JSTL의 출력과 포맷을 적용할 수 있는 태그 라이브러리 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>
<!-- 해당 전 까지 header.jsp에 작성하고 인클루드 하는 형식으로 구현할래  -->
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Tables</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">DataTables Advanced Tables</div>
			<div class="panel-heading">Board List Page
				<!-- change <a href> as JQuery Script -->
				<button id="regBtn" type="button" class="btn btn-xs pull-right">Register New Board</button>
			</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<table width="100%"
					class="table table-striped table-bordered table-hover">
					<!-- id="dataTables-example" -->
					<thead>
						<tr>
							<th>BNO</th>
							<th>Title</th>
							<th>Writer</th>
							<th>RegDate</th>
							<th>UpdateDate</th>
						</tr>
					</thead>
					<tbody>
						<!-- JSTL의 loop문 -->
						<c:forEach items="${list}" var="board" >

							<tr class="odd gradeX">
							<!-- a태그 추가 -->
								<td><c:out value="${board.bno}"/></td>
								
								
								<!-- ch14. 검색조건이 복잡해지면 이렇게 됐을때 힘들다. 번호만 남겨보자 -->
								<td><a class="move" href="<c:out value="${board.bno}"/>">
									<c:out value="${board.title}"/></a></td>
								<td><c:out value="${board.writer}"/></td>
								<!-- 포맷팅fmt -->
								<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
								<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate}"/></td>													
							</tr>
						</c:forEach>
					</tbody>
				</table>
				<!-- /.table-responsive 잘라냄  -->
				
				
				<!-- show search bar 0216 -->
				<form id="searchForm" action="/board/list" method="get">
					<!--  -->
					<select name="type">
						<option value="" ${pageMaker.cri.type==null?"selected":""} >---</option>
						<option value="T" ${pageMaker.cri.type eq 'T'?"selected":""} >제목</option>
						<option value="C" ${pageMaker.cri.type eq 'C'?"selected":""} >내용</option>
						<option value="W" ${pageMaker.cri.type eq 'W'?"selected":""} >작성자</option>
						<option value="TC" ${pageMaker.cri.type eq 'TC'?"selected":""} >제목+내용</option>
						<option value="TCW" ${pageMaker.cri.type eq 'TCW'?"selected":""} >제목+내용+작성자</option>											
					</select> 
					<input type="text" name="keyword" value="${pageMaker.cri.keyword}">
					<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}"> 
					<input type="hidden" name="amount" value="${pageMaker.cri.amount}"> 
					<button class="btn btn-default">Search</button>
				</form>				
				
				
				<!-- show pagination in JSP coded on 0207-->
				<h3>${pageMaker}</h3>
				<div class="pull-right">
					<ul class="pagination">
					
						<!-- showing prev button -->
						<c:if test="${pageMaker.prev}">
							<li class="page-item">
								<a class="page-link" href="${pageMaker.startPage-1}" tabindex="-1">Previous</a>
							</li>
						</c:if>
						<!-- looping for pagination -->
						<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="num">
							<li class="page-item ${pageMaker.cri.pageNum == num ? "active" : ""} "><a class="page-link" href="${num}">${num}</a></li>
						</c:forEach>
						<!-- showing next button -->
						<c:if test="${pageMaker.next}">
							<li class="page-item">
								<a class="page-link" href="${pageMaker.endPage+1}">Next</a>
							</li>
						</c:if>
					</ul>		
				</div><!-- /.pull-right -->
				<!-- actionForm for pagination -->
				<form id="actionForm" action="/board/list" method="get">
					<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
					<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
					
					<!-- ch15.에서 추가 검색조건이 계속 따라 붙죠-->
					<input type="hidden" name="type" value="${pageMaker.cri.type}">
					<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
					<!-- javascript에서 jQuery이용해 여기에 append 하게 됨 -->					
				</form>
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-12 -->
</div>

<!-- using bootstrap modal  -->
<div id="myModal" class="modal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Modal title</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p>Modal body text goes here.</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary">Save changes</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- BoardController의 bno 관련  -->
<script>
$(document).ready(function(){
	var result = '<c:out value = "${result}"/>';
	
	<!-- Using JQuery to show Modal above-->
	checkModal(result);
	history.replaceState({},null,null);
	
	function checkModal(result){
		if(result==='' || history.state)
			return;
		
		if(parseInt(result)>0){
			$(".modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.");
		}else if(result === 'success'){
			$(".modal-body").html("정상적으로 처리되었습니다.");
		}
		$("#myModal").modal("show");
	}
	$("#regBtn").on("click",function(){
		self.location="/board/register"; // window.location means equal with self.location
	});

	/* javascript for pagination especially to use form way*/
	var actionForm = $("#actionForm");

	$(".page-link").on("click", function(e){
		e.preventDefault();
		/*actionForm의 pageNum을 찾아서 val 을 바꿔줘야함*/
		var targetPage = $(this).attr("href");

		console.log(targetPage);

		actionForm.find("input[name='pageNum']").val(targetPage); //url에서 

		actionForm.submit(); //실제로 페이지 이동이 되는거종

	});

	$(".move").on("click",function(e){
		e.preventDefault();

		var targetBno = $(this).attr("href");

		console.log(targetBno);
		/* 기존 */
		actionForm.append("<input type='hidden' name='bno' value='"+targetBno+"'>'");
		actionForm.attr("action","/board/get").submit(); //chaining, it is equal to actionForm.submit(); 

		/* */
	});


	/*p340 15.4 화면에서 검색 조건 처리*/
	var searchForm = $("#searchForm");

	$("#searchForm button").on("click", function(e){
		e.preventDefault(); // 기본 막음
		console.log(".............click");
		/* modal 로 해보자 */
		if(!searchForm.find("option:selected").val()){
			$(".modal-body").html("검색 종류를 선택하세요");
			$("#myModal").modal("show");
			return false;
			
		}
		if(!searchForm.find("input[name='keyword']").val()){
			$(".modal-body").html("키워드를 입력하세요");
			$("#myModal").modal("show");
			return false;
		}

		
		/* 항상 검색은 1페이지 부터*/
		searchForm.find("input[name='pageNum']").val(1);
		
		searchForm.submit();

	});
		
	
});


</script>
<!-- /.row -->
<!-- /.row -->
<!-- /.row 잘라냄 -->
<!-- page-wrapper 끝나는 곳 부터 잘라낸다 footer를 위해  -->
<%@include file="../includes/footer.jsp"%>