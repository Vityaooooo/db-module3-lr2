// работа с базой данных.
const Mysql = require('sync-mysql')
const connection = new Mysql({
    host:'localhost', 
    user:'root', 
    password:'1234', 
    database:'lr_2'
})

const path = require('path');
const fs = require('fs');
const qs = require('querystring');
const http = require('http');

// обработка параметров из формы.
function reqPost (request, response) {
    if (request.method == 'POST') {
        let body = '';

        request.on('data', function (data) {
            body += data;
        });

        request.on('end', function () {
			const post = qs.parse(body);
			const sInsert = `INSERT INTO sector (coordinates, light_rotation, foreign_object, sky_object_count, unknown_object_count, specified_object_count, notes) 
                            VALUES ("${post['coordinates']}", ${post['light_rotation']}, ${post['foreign_object']}, ${post['sky_object_count']}, ${post['unknown_object_count']}, ${post['specified_object_count']}, "${post['notes']}")`;
			const results = connection.query(sInsert);
            console.log('Done. Hint: '+sInsert);
        });
    }
}

// выгрузка массива данных.
function ViewSelect(res) {
    const query = 'SELECT * FROM sector';
    const results = connection.query(query);

    res.write('<tr>');
    for (let key in results[0]) {
        res.write('<th>' + key + '</th>');
    }
    res.write('</tr>');

    for (let row of results) {
        res.write('<tr>');
        for (let key in row) {
            res.write('<td>' + row[key] + '</td>');
        }
        res.write('</tr>');
    }
}

function ViewVer(res) {
	const results = connection.query('SELECT VERSION() AS ver');
	res.write(results[0].ver);
}

// создание ответа в браузер, на случай подключения.
const server = http.createServer((req, res) => {
	reqPost(req, res);
	console.log('Loading...');
	
	res.statusCode = 200;
//	res.setHeader('Content-Type', 'text/plain');

	// чтение шаблока в каталоге со скриптом.
	const filePath = path.join(__dirname, 'select.html')
	const array = fs.readFileSync(filePath).toString().split("\n");
	console.log(filePath);

	for(let i in array) {
		// подстановка.
		if ((array[i].trim() != '@tr') && (array[i].trim() != '@ver')) res.write(array[i]);
		if (array[i].trim() == '@tr') ViewSelect(res);
		if (array[i].trim() == '@ver') ViewVer(res);
	}
	res.end();
	console.log('1 User Done.');
});

// запуск сервера, ожидание подключений из браузера.
const hostname = '127.0.0.1';
const port = 3000;
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
