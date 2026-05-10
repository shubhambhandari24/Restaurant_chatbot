<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.ai.restaurant.model.Order"%>
<%@ page import="com.ai.restaurant.service.OrderService"%>

<%
Integer userId = (Integer) session.getAttribute("userId");

if (userId == null) {
    response.sendRedirect("../login.jsp");
    return;
}

OrderService orderService = new OrderService();
List<Order> orders = orderService.getUserOrders(userId);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order History</title>

<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box
}

body {
	background: #0b0b0f;
	color: white;
	font-family: Arial, sans-serif;
	padding: 40px;
}

.wrapper {
	max-width: 900px;
	margin: auto;
}

.top {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 25px;
}

.top h1 {
	color: #d4af37;
}

.top a {
	background: #d4af37;
	color: #000;
	padding: 12px 18px;
	text-decoration: none;
	border-radius: 8px;
	font-weight: bold;
}

.card {
	background: #15151f;
	border: 1px solid rgba(212, 175, 55, .25);
	border-radius: 18px;
	padding: 25px;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th {
	color: #d4af37;
	text-align: left;
	padding: 14px;
	border-bottom: 1px solid #333;
}

td {
	padding: 14px;
	border-bottom: 1px solid #2c2c35;
}

.status {
	font-weight: bold;
}

.pending {
	color: orange
}

.preparing {
	color: #00aaff
}

.ready {
	color: green
}

.served {
	color: #ff6b6b
}

.empty {
	text-align: center;
	padding: 40px;
	color: #aaa;
}
</style>
</head>

<body>

	<div class="wrapper">

		<div class="top">
			<h1>Order History</h1>
			<a href="chat.jsp">Back to Chat</a>
		</div>

		<div class="card">

			<% if (orders == null || orders.isEmpty()) { %>

			<div class="empty">
				<h2>No orders yet</h2>
				<p>Start ordering from chatbot.</p>
			</div>

			<% } else { %>

			<table>
				<tr>
					<th>ID</th>
					<th>Table</th>
					<th>Status</th>
					<th>Total</th>
					<th>Date</th>
				</tr>

				<% for (Order order : orders) { %>
				<tr>
					<td>#<%= order.getId() %></td>
					<td><%= order.getTableNumber() %></td>

					<td class="status <%= order.getStatus() %>"><%= order.getStatus() %>
					</td>

					<td>&#8377;<%= order.getTotalPrice() %></td>
					<td><%= order.getCreatedAt() %></td>
				</tr>
				<% } %>
			</table>

			<% } %>

		</div>

	</div>

</body>
</html>