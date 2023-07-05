<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
   body, html {
        height: 100%;
        margin: 0;
    }

    .container {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100%;
    }

    form {
        font-size: 1.5em;
    }

    .input-field {
        display: flex;
        justify-content: flex-start;
        margin: 15px 0;
    }

    .input-field label {
        margin-right: 15px;
        width: 200px; /* Adjust this value to align input fields */
        text-align: right; /* Align text to the right within the label */
    }

    input, select {
        padding: 10px;
        font-size: 1em;
    }

    h2 {
        font-size: 2em;
        margin-bottom: 20px;
        text-align: center;
    }

    .submit-button {
        display: flex;
        justify-content: center;
        margin: 20px 0;
    }
</style>
</head>
<body>

    <div class="container">
        <form action="yourRegistrationServlet" method="post">

            <h2>정보 입력</h2>

            <div class="input-field">
                <label for="m_name">이름:</label>
                <input type="text" id="m_name" name="m_name">
            </div>

            <div class="input-field">
                <label for="m_gender">성별:</label>
                <select id="m_gender" name="m_gender">
                    <option value="male">남성</option>
                    <option value="female">여성</option>
                </select>
            </div>

            <div class="input-field">
                <label for="m_weight">체중 (kg):</label>
                <input type="number" id="m_weight" name="m_weight" step="any">
            </div>

            <div class="input-field">
                <label for="m_height">키 (cm):</label>
                <input type="number" id="m_height" name="m_height" step="any">
            </div>

            <div class="input-field">
                <label for="m_tel">전화번호:</label>
                <input type="text" id="m_tel" name="m_tel">
            </div>

            <div class="input-field">
                <label for="m_target_calorie">하루&nbsp;목표&nbsp;칼로리:</label>
                <input type="text" id="m_target_calorie" name="m_target_calorie">
            </div>

            <div class="input-field">
                <label for="m_target_weight">목표 체중:</label>
                <input type="text" id="m_target_weight" name="m_target_weight">
            </div>

            <div class="submit-button">
                <input type="submit" value="Register">
            </div>

        </form>
    </div>
</body>
</html>