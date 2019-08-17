const express = require('express');

const app = express();

app.get('/', (req, res) => {
    res.send('Hi lucas');
});

app.listen(8080, () =>{
    console.log('Listning on 8080');
});