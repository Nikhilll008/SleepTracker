
<%@ page import="java.sql.*" %>
<%@ page import="com.sleeptracker.DBConnection" %>

<html>
<head>
    <title>Sleep Tracker</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<h2>All Records</h2>

<%
String person = request.getParameter("person");
String date = request.getParameter("sleep_date");
String h = request.getParameter("hours");

if (person != null && date != null && h != null) {
    double hours = Double.parseDouble(h);

    if (hours >= 0 && hours <= 24) {
        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO sleep_log(person, sleep_date, hours) VALUES(?,?,?)");

        ps.setString(1, person);
        ps.setDate(2, java.sql.Date.valueOf(date));
        ps.setDouble(3, hours);
        ps.executeUpdate();

        ps.close();
        con.close();
    } else {
        out.println("Hours must be between 0 and 24");
    }
}
%>

<table border="1" cellpadding="5" cellspacing="0" width="100%">
<tr>
    <th>ID</th>
    <th>Person</th>
    <th>Date</th>
    <th>Hours Slept</th>
    <th>Sleep</th>
</tr>

<%
Connection con = DBConnection.getConnection();
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM sleep_log");

double total = 0;
int count = 0;

while (rs.next()) {
    double hours = rs.getDouble("hours");
    String sleep;

    if (hours < 6)
        sleep = "Low";
    else if (hours <= 9)
        sleep = "Good";
    else
        sleep = "Long";

    total += hours;
    count++;
%>

<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("person") %></td>
    <td><%= rs.getDate("sleep_date") %></td>
    <td><%= hours %></td>
    <td><%= sleep %></td>
</tr>

<%
}
rs.close();
st.close();
con.close();
%>

</table>

<p>
Average Hours Slept:
<b><%= count == 0 ? "0.00" :
    String.format(java.util.Locale.US, "%.2f", total / count) %></b>
</p>

<br>
<a href="index.html">Add Another Record</a>

</body>
</html>
