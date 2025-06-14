<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<%@ page import="java.util.UUID" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%
    String id = request.getParameter("id");
    String vehicleNo = "";
    String driverName = "";
    String csrfToken = UUID.randomUUID().toString();
    session.setAttribute("csrf_token", csrfToken);

    if (id != null && !id.trim().isEmpty()) {
        try {
            Integer.parseInt(id); // Validate ID
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "SELECT vehicle_no, employee_name FROM vehicle_entry_requests WHERE id = ?")) {
                ps.setString(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        vehicleNo = rs.getString("vehicle_no");
                        driverName = rs.getString("employee_name");
                    } else {
                        out.println("<p style='color:red;'>Error: No vehicle found for the given ID.</p>");
                    }
                }
            }
        } catch (NumberFormatException e) {
            out.println("<p style='color:red;'>Error: Invalid ID format.</p>");
        } catch (SQLException e) {
            out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p style='color:red;'>Error: ID parameter is missing.</p>");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Vehicle Log Sheet</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #e0eafc, #cfdef3);
            color: #333;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 1100px;
            margin: 40px auto;
            background-color: #fff;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #003366;
            margin-bottom: 25px;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: 600;
        }
        input[type="text"],
        input[type="number"],
        input[type="datetime-local"],
        textarea {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            width: 100%;
            box-sizing: border-box;
            margin-top: 5px;
        }
        table.styled-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        table.styled-table th,
        table.styled-table td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }
        table.styled-table th {
            background-color: #f0f8ff;
            color: #003366;
        }
        textarea {
            resize: vertical;
            min-height: 60px;
        }
        .btn, button {
            margin-top: 20px;
            margin-right: 10px;
            padding: 10px 20px;
            background-color: #005a9e;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .btn:hover, button:hover {
            background-color: #003e73;
        }
        #form-errors {
            margin-top: 20px;
            color: red;
            text-align: center;
            font-weight: bold;
        }
        .error-message {
            color: red;
            font-size: 12px;
            display: block;
        }
        #toast {
            display: none;
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background-color: #f44336;
            color: white;
            padding: 15px 30px;
            border-radius: 5px;
            z-index: 9999;
        }
        @media print {
            .navbar, .footer, .btn, button, input[type="button"],
            .page-wrapper > .navbar, .page-wrapper > .footer {
                display: none !important;
            }
            .container {
                box-shadow: none;
                padding: 0;
                border-radius: 0;
                background: white;
            }
            table.styled-table,
            table.styled-table th,
            table.styled-table td {
                border: 1px solid #000 !important;
                background: white;
            }
            table.styled-table input,
            table.styled-table textarea {
                border: none !important;
                outline: none !important;
                background: transparent;
                font-size: 15px;
                padding: 4px;
            }
            table.styled-table textarea {
                resize: none;
                height: auto;
                min-height: 50px;
                white-space: pre-wrap;
                overflow: visible;
            }
            #vehicle_no, #driver_name {
                border: 1px solid #000 !important;
                background: white;
            }
            body {
                background: white;
            }
        }
    </style>
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="navbar.jsp" />
    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <div style="display: flex; align-items: center;">
                <img src="images/bhel_logo.png" alt="BHEL Logo" style="height: 60px; margin-right: 15px;">
                <div>
                    <strong>HP & VP</strong><br>
                    Visakhapatnam - 12
                </div>
            </div>
            <div id="log-date" style="font-weight: bold; font-size: 16px;"></div>
        </div>
        <h2>Vehicle Log Sheet</h2>
        <form action="save_log_sheet.jsp" method="post" id="logForm">
            <input type="hidden" name="csrf_token" value="<%= csrfToken %>">
            <label for="vehicle_no">Vehicle No:</label>
            <input type="text" name="vehicle_no" id="vehicle_no" value="<%= vehicleNo %>" readonly required>
            <label for="driver_name">Name of Driver:</label>
            <input type="text" name="driver_name" id="driver_name" value="<%= driverName %>" readonly required>
            <table id="logTable" class="styled-table">
                <thead>
                    <tr>
                        <th>Sl No</th>
                        <th>Start Time</th>
                        <th>Close Time</th>
                        <th>Places Visited</th>
                        <th>Meter Start</th>
                        <th>Meter Close</th>
                        <th>No. of KM</th>
                        <th>Purpose of Journey</th>
                        <th>Petrol/Lubricants (Liters)</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td><input type="datetime-local" name="start_time[]" required step="60">
                            <span class="error-message"></span></td>
                        <td><input type="datetime-local" name="close_time[]" required step="60">
                            <span class="error-message"></span></td>
                        <td><input type="text" name="places[]" required maxlength="100">
                            <span class="error-message"></span></td>
                        <td><input type="number" name="meter_start[]" min="0" step="1" required oninput="preventNegative(this); validateRow(this.closest('tr'))">
                            <span class="error-message"></span></td>
                        <td><input type="number" name="meter_close[]" min="1ioen" step="1" required oninput="preventNegative(this); validateRow(this.closest('tr'))">
                            <span class="error-message"></span></td>
                        <td><input type="number" name="km[]" min="0" step="1" readonly>
                            <span class="error-message"></span></td>
                        <td><textarea name="purpose[]" required maxlength="500" oninput="validateRow(this.closest('tr'))"></textarea>
                            <span class="error-message"></span></td>
                        <td><input type="text" name="fuel[]" required pattern="^\d+(\.\d{1,2})?$" title="Enter valid fuel quantity (e.g., 5 or 5.5 or 5.55)" oninput="validateRow(this.closest('tr'))">
                            <span class="error-message"></span></td>
                    </tr>
                </tbody>
            </table>
            <ul id="form-errors"></ul>
            <button type="button" onclick="addRow()">Add Row</button>
            <input type="submit" value="Submit Log Sheet" class="btn">
            <input type="button" value="Print" onclick="window.print()" class="btn">
        </form>
    </div>
    <div id="toast"></div>
    <jsp:include page="footer.jsp" />
</div>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const today = new Date();
        document.getElementById("log-date").textContent = "Date: " + today.toLocaleDateString('en-IN', {
            day: '2-digit',
            month: 'short',
            year: 'numeric'
        });
        validateRow(document.querySelector('#logTable tbody tr'));
    });

    function addRow() {
        const table = document.getElementById("logTable").getElementsByTagName('tbody')[0];
        const row = table.insertRow();
        row.innerHTML = `
            <td></td>
            <td><input type="datetime-local" name="start_time[]" required step="60">
                <span class="error-message"></span></td>
            <td><input type="datetime-local" name="close_time[]" required step="60">
                <span class="error-message"></span></td>
            <td><input type="text" name="places[]" required maxlength="100">
                <span class="error-message"></span></td>
            <td><input type="number" name="meter_start[]" min="0" step="1" required oninput="preventNegative(this); validateRow(this.closest('tr'))">
                <span class="error-message"></span></td>
            <td><input type="number" name="meter_close[]" min="1" step="1" required oninput="preventNegative(this); validateRow(this.closest('tr'))">
                <span class="error-message"></span></td>
            <td><input type="number" name="km[]" min="0" step="1" readonly>
                <span class="error-message"></span></td>
            <td><textarea name="purpose[]" required maxlength="500" oninput="validateRow(this.closest('tr'))"></textarea>
                <span class="error-message"></span></td>
            <td><input type="text" name="fuel[]" required pattern="^\\d+(\\.\\d{1,2})?$" title="Enter valid fuel quantity (e.g., 5 or 5.5 or 5.55)">
                <span class="error-message"></span></td>
        `;
        updateSerialNumbers();
        validateRow(row);
    }

    function updateSerialNumbers() {
        const rows = document.getElementById("logTable").getElementsByTagName('tbody')[0].rows;
        Array.from(rows).forEach((row, i) => row.cells[0].innerText = i + 1);
    }

    function preventNegative(input) {
        if (input.value < input.min) {
            input.value = '';
            input.nextElementSibling.textContent = `Must be at least ${input.min}`;
        } else {
            input.nextElementSibling.textContent = "";
        }
    }

    function updateKm(row) {
        const meterStart = parseInt(row.querySelector('[name="meter_start[]"]').value) || 0;
        const meterClose = parseInt(row.querySelector('[name="meter_close[]"]').value) || 0;
        const kmInput = row.querySelector('[name="km[]"]');
        if (meterStart >= 0 && meterClose > 0 && meterClose >= meterStart) {
            kmInput.value = meterClose - meterStart;
            kmInput.nextElementSibling.textContent = "";
        } else {
            kmInput.value = '';
            kmInput.nextElementSibling.textContent = meterClose <= meterStart ? "Meter Close must be > Meter Start" : "";
        }
    }

    function validateRow(row) {
        const inputs = {
            startTime: row.querySelector('[name="start_time[]"]'),
            closeTime: row.querySelector('[name="close_time[]"]'),
            place: row.querySelector('[name="places[]"]'),
            meterStart: row.querySelector('[name="meter_start[]"]'),
            meterClose: row.querySelector('[name="meter_close[]"]'),
            km: row.querySelector('[name="km[]"]'),
            purpose: row.querySelector('[name="purpose[]"]'),
            fuel: row.querySelector('[name="fuel[]"]')
        };

        function validateField() {
            // Only validate when fields have values
            if (inputs.startTime.value && inputs.closeTime.value) {
                const start = new Date(inputs.startTime.value);
                const close = new Date(inputs.closeTime.value);
                const diffMs = close - start;
                const diffHours = diffMs / (1000 * 60 * 60);
                inputs.closeTime.nextElementSibling.textContent = 
                    (close > start && diffHours <= 24) ? '' : 
                    (close <= start ? 'Must be after Start Time' : 'Time difference must not exceed 24 hours');
            } else {
                inputs.startTime.nextElementSibling.textContent = '';
                inputs.closeTime.nextElementSibling.textContent = '';
            }

            if (inputs.place.value) {
                inputs.place.nextElementSibling.textContent = inputs.place.value.trim() ? '' : 'Required';
            } else {
                inputs.place.nextElementSibling.textContent = '';
            }

            if (inputs.purpose.value) {
                inputs.purpose.nextElementSibling.textContent = inputs.purpose.value.trim() ? '' : 'Required';
            } else {
                inputs.purpose.nextElementSibling.textContent = '';
            }

            if (inputs.fuel.value) {
                inputs.fuel.nextElementSibling.textContent = 
                    /^\d+(\.\d{1,2})?$/.test(inputs.fuel.value) ? '' : 'Invalid format (e.g., 5 or 5.5)';
            } else {
                inputs.fuel.nextElementSibling.textContent = '';
            }

            const meterStart = parseInt(inputs.meterStart.value) || -1;
            const meterClose = parseInt(inputs.meterClose.value) || -1;

            if (inputs.meterStart.value !== '') {
                inputs.meterStart.nextElementSibling.textContent = meterStart >= 0 ? '' : 'Must be non-negative';
            } else {
                inputs.meterStart.nextElementSibling.textContent = '';
            }

            if (inputs.meterClose.value !== '') {
                inputs.meterClose.nextElementSibling.textContent = meterClose > 0 ? '' : 'Must be positive';
            } else {
                inputs.meterClose.nextElementSibling.textContent = '';
            }

            if (meterStart >= 0 && meterClose > 0) {
                updateKm(row);
            }
        }

        Object.values(inputs).forEach(el => {
            el.addEventListener('input', validateField);
            el.addEventListener('change', validateField);
        });

        validateField();
    }

    document.getElementById("logForm").addEventListener("submit", e => {
        e.preventDefault();
        const errorContainer = document.getElementById("form-errors");
        errorContainer.innerHTML = "";
        document.querySelectorAll(".error-message").forEach(span => span.textContent = "");
        const rows = document.querySelectorAll("#logTable tbody tr");
        let hasError = false;

        rows.forEach((row, index) => {
            const inputs = {
                startTime: row.querySelector('[name="start_time[]"]'),
                closeTime: row.querySelector('[name="close_time[]"]'),
                place: row.querySelector('[name="places[]"]'),
                meterStart: row.querySelector('[name="meter_start[]"]'),
                meterClose: row.querySelector('[name="meter_close[]"]'),
                km: row.querySelector('[name="km[]"]'),
                purpose: row.querySelector('[name="purpose[]"]'),
                fuel: row.querySelector('[name="fuel[]"]')
            };

            const values = {
                startTime: inputs.startTime.value,
                closeTime: inputs.closeTime.value,
                place: inputs.place.value.trim(),
                meterStart: parseInt(inputs.meterStart.value) || -1,
                meterClose: parseInt(inputs.meterClose.value) || -1,
                km: parseInt(inputs.km.value) || -1,
                purpose: inputs.purpose.value.trim(),
                fuel: inputs.fuel.value.trim()
            };

            if (!values.startTime) {
                inputs.startTime.nextElementSibling.textContent = "Required";
                hasError = true;
            }
            if (!values.closeTime) {
                inputs.closeTime.nextElementSibling.textContent = "Required";
                hasError = true;
            }
            if (values.startTime && values.closeTime) {
                const start = new Date(values.startTime);
                const close = new Date(values.closeTime);
                const diffMs = close - start;
                const diffHours = diffMs / (1000 * 60 * 60);
                if (close <= start) {
                    inputs.closeTime.nextElementSibling.textContent = "Must be after Start Time";
                    hasError = true;
                } else if (diffHours > 24) {
                    inputs.closeTime.nextElementSibling.textContent = "Time difference must not exceed 24 hours";
                    hasError = true;
                }
            }
            if (!values.place) {
                inputs.place.nextElementSibling.textContent = "Required";
                hasError = true;
            }
            if (values.meterStart < 0) {
                inputs.meterStart.nextElementSibling.textContent = "Must be non-negative";
                hasError = true;
            }
            if (values.meterClose <= 0) {
                inputs.meterClose.nextElementSibling.textContent = "Must be positive";
                hasError = true;
            }
            if (values.meterStart >= 0 && values.meterClose > 0 && 
                values.meterClose <= values.meterStart) {
                inputs.meterClose.nextElementSibling.textContent = "Must be > Meter Start";
                hasError = true;
            }
            if (values.km <= 0) {
                inputs.km.nextElementSibling.textContent = "Must be positive";
                hasError = true;
            }
            if (values.meterStart >= 0 && values.meterClose > 0 && values.km > 0 &&
                (values.meterClose - values.meterStart) !== values.km) {
                inputs.km.nextElementSibling.textContent = "Must equal Meter Close - Meter Start";
                hasError = true;
            }
            if (!values.purpose) {
                inputs.purpose.nextElementSibling.textContent = "Required";
                hasError = true;
            }
            if (!values.fuel) {
                inputs.fuel.nextElementSibling.textContent = "Required";
                hasError = true;
            } else if (!/^\d+(\.\d{1,2})?$/.test(values.fuel)) {
                inputs.fuel.nextElementSibling.textContent = "Invalid format (e.g., 5 or 5.5)";
                hasError = true;
            }
        });

        if (hasError) {
            showToast("Please fix the errors in the form.");
            return;
        }
        e.target.submit();
    });

    function showToast(message) {
        const toast = document.getElementById("toast");
        toast.textContent = message;
        toast.style.display = "block";
        setTimeout(() => toast.style.display = "none", 3000);
    }
</script>
</body>
</html>