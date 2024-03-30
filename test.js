function sum() {
    var num1 = parseInt(document.getElementById('number1').value);
    var num2 = parseInt(document.getElementById('number2').value);

    var sum = num1 + num2;

    document.getElementById('result').innerText = 'Tổng: ' + sum;
    document.getElementById('result').style.display='block';
}
function difference() {
    var num1 = parseInt(document.getElementById('number1').value);
    var num2 = parseInt(document.getElementById('number2').value);

    var difference = num1 - num2;

    document.getElementById('result').innerText = 'Hiệu: ' + difference;
    document.getElementById('result').style.display='block';
}