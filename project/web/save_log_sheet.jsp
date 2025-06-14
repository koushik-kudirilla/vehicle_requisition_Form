<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="utils.DBConnection" %>
<%!
    public String sanitizeInput(String input) {
        if (input == null) return "";
        return input.replaceAll("[<>\"&']", "");
    }
%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String csrfToken = request.getParameter("csrf_token");
    String sessionCsrfToken = (String) session.getAttribute("csrf_token");
    
    if (csrfToken == null || !csrfToken.equals(sessionCsrfToken)) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
        return;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String logDate = sdf.format(new java.util.Date());
    String vehicleNo = sanitizeInput(request.getParameter("vehicle_no"));
    String driverName = sanitizeInput(request.getParameter("driver_name"));

    if (vehicleNo.isEmpty() || driverName.isEmpty()) {
        out.println("<p style='color:red;'>Error: Vehicle Number or Driver Name is missing.</p>");
        return;
    }

    String[] startTimes = request.getParameterValues("start_time[]");
    String[] closeTimes = request.getParameterValues("close_time[]");
    String[] places = request.getParameterValues("places[]");
    String[] meterStart = request.getParameterValues("meter_start[]");
    String[] meterClose = request.getParameterValues("meter_close[]");
    String[] kms = request.getParameterValues("km[]");
    String[] purposes = request.getParameterValues("purpose[]");
    String[] fuels = request.getParameterValues("fuel[]");

    if (startTimes == null || closeTimes == null || places == null || meterStart == null ||
        meterClose == null || kms == null || purposes == null || fuels == null ||
        !Arrays.stream(new String[][]{startTimes, closeTimes, places, meterStart, 
            meterClose, kms, purposes, fuels}).allMatch(arr -> arr.length == startTimes.length)) {
        out.println("<p style='color:red;'>Error: Form data is incomplete or inconsistent.</p>");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false);

        int nextEntryNo = 1;
        try (PreparedStatement maxPs = conn.prepareStatement(
                "SELECT MAX(entry_no) FROM vehicle_log_sheet WHERE vehicle_no = ? AND log_date = ?")) {
            maxPs.setString(1, vehicleNo);
            maxPs.setString(2, logDate);
            try (ResultSet rs = maxPs.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    nextEntryNo = rs.getInt(1) + 1;
                }
            }
        }

        String sql = "INSERT INTO vehicle_log_sheet (vehicle_no, driver_name, log_date, entry_no, " +
                     "start_time, close_time, places_visited, meter_start, meter_close, km, purpose, fuel) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        SimpleDateFormat timeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        for (int i = 0; i < startTimes.length; i++) {
            int meterStartVal = Integer.parseInt(meterStart[i]);
            int meterCloseVal = Integer.parseInt(meterClose[i]);
            int kmVal = Integer.parseInt(kms[i]);
            double fuelVal = Double.parseDouble(fuels[i]);

            java.util.Date startDateTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(startTimes[i]);
            java.util.Date closeDateTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(closeTimes[i]);

            long diffMs = closeDateTime.getTime() - startDateTime.getTime();
            long diffHours = diffMs / (1000 * 60 * 60);

            if (closeDateTime.compareTo(startDateTime) <= 0) {
                throw new Exception("Close Time must be after Start Time in row " + (i + 1));
            }
            if (diffHours > 24) {
                throw new Exception("Time difference must not exceed 24 hours in row " + (i + 1));
            }
            if (meterStartVal < 0) {
                throw new Exception("Meter Start must be non-negative in row " + (i + 1));
            }
            if (meterCloseVal <= 0) {
                throw new Exception("Meter Close must be positive in row " + (i + 1));
            }
            if (meterCloseVal <= meterStartVal) {
                throw new Exception("Meter Close must be > Meter Start in row " + (i + 1));
            }
            if (kmVal <= 0) {
                throw new Exception("KM must be positive in row " + (i + 1));
            }
            if (kmVal != (meterCloseVal - meterStartVal)) {
                throw new Exception("KM must equal Meter Close - Meter Start in row " + (i + 1));
            }
            if (startTimes[i].isEmpty() || closeTimes[i].isEmpty() || 
                sanitizeInput(places[i]).isEmpty() || sanitizeInput(purposes[i]).isEmpty()) {
                throw new Exception("Required fields missing in row " + (i + 1));
            }
            if (!fuels[i].matches("^\\d+(\\.\\d{1,2})?$")) {
                throw new Exception("Invalid fuel format in row " + (i + 1));
            }

            ps.setString(1, vehicleNo);
            ps.setString(2, driverName);
            ps.setString(3, logDate);
            ps.setInt(4, nextEntryNo++);
            ps.setTimestamp(5, new Timestamp(startDateTime.getTime()));
            ps.setTimestamp(6, new Timestamp(closeDateTime.getTime()));
            ps.setString(7, sanitizeInput(places[i]));
            ps.setInt(8, meterStartVal);
            ps.setInt(9, meterCloseVal);
            ps.setInt(10, kmVal);
            ps.setString(11, sanitizeInput(purposes[i]));
            ps.setDouble(12, fuelVal);
            ps.addBatch();
        }

        ps.executeBatch();
        conn.commit();
        session.removeAttribute("csrf_token");
        out.println("<h3 style='color:green;'>Log Sheet Submitted Successfully!</h3>");
        out.println("<script>setTimeout(() => { window.location.href = 'user_home.jsp'; }, 2000);</script>");
    } catch (SQLException e) {
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
        out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
    } catch (Exception e) {
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (ps != null) try { ps.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>