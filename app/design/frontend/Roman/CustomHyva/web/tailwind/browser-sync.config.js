const path = require('path');
const url = require('url');
const fs = require('fs');

let baseDir = path.resolve(__dirname);
do {
    baseDir = baseDir.split('/').slice(0, -1).join('/');
} while (baseDir !== '' && ! fs.existsSync(baseDir + '/app'));

if (baseDir === '') {
    console.log('ERROR: unable to locate Magento base directory.');
    console.log('Please run this script somewhere within a Magento project.');
    require('process').exit(1)
}

const proxy = process.env.PROXY_URL || 'http://magento.local/';
const port = process.env.PORT || 3000;
const { host } = url.parse(proxy);

if (typeof process.env.PROXY_URL === 'undefined') {
    console.log('Set an alternative proxy host using');
    console.log('PROXY_URL="https://my-magento.test" npm run browser-sync', "\n");
}

module.exports = {
    proxy,
    port,
    rewriteRules: [
        {
            match: `.${host}`,
            replace: '',
        },
    ],
    files: [
        `${baseDir}/**/*.js`,
        `${baseDir}/**/*.css`,
        `${baseDir}/**/*.xml`,
        `${baseDir}/**/*.phtml`,
    ],
};

