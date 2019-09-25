___INFO___

{
  "displayName": "Sklik retargeting",
  "description": "Retargeting s custom parametry",
  "securityGroups": [],
  "id": "cvt_temp_public_id",
  "type": "TAG",
  "version": 1,
  "brand": {
    "displayName": "",
    "id": "brand_dummy"
  },
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "help": "The number (e.g. 123456) from your retargeting code... \n\"seznam_retargeting_id = 123456;\"",
    "valueValidators": [
      {
        "enablingConditions": [],
        "errorMessage": "This must be a number",
        "type": "POSITIVE_NUMBER"
      },
      {
        "type": "NON_EMPTY"
      }
    ],
    "displayName": "Sklik Retargeting ID",
    "simpleValueType": true,
    "name": "SklikID",
    "type": "TEXT"
  },
  {
    "displayName": "Standard Sklik Dynamic Retargeting Params",
    "name": "StandardSklikParams",
    "groupStyle": "ZIPPY_OPEN_ON_PARAM",
    "type": "GROUP",
    "subParams": [
      {
        "help": "GTM Variable returning values undefined, 'category' or 'offerdetail'",
        "displayName": "seznam_pagetype",
        "simpleValueType": true,
        "name": "seznam_pagetype",
        "type": "TEXT",
        "valueHint": "{{seznam_pagetype}}"
      },
      {
        "help": "GTM Variable returning category name values or undefined",
        "displayName": "seznam_category",
        "simpleValueType": true,
        "name": "seznam_category",
        "type": "TEXT",
        "valueHint": "{{seznam_category}}"
      },
      {
        "help": "GTM Variable returning product ID (e.g. on pages where seznam_pagetype is 'offerdetail') values or undefined",
        "displayName": "seznam_itemId",
        "simpleValueType": true,
        "name": "seznam_itemId",
        "type": "TEXT",
        "valueHint": "{{seznam_itemId}}"
      }
    ]
  },
  {
    "displayName": "Custom Variables",
    "name": "CustomVariables",
    "groupStyle": "ZIPPY_OPEN_ON_PARAM",
    "type": "GROUP",
    "subParams": [
      {
        "displayName": "",
        "name": "CustomVarsTable",
        "simpleTableColumns": [
          {
            "valueValidators": [
              {
                "args": [
                  "^[a-zA-Z0-9_-]+$"
                ],
                "enablingConditions": [],
                "errorMessage": "Please only use characters: a-z, 0-9, _, -",
                "type": "REGEX"
              },
              {
                "type": "NON_EMPTY"
              }
            ],
            "defaultValue": "",
            "displayName": "Variable Name",
            "name": "VariableName",
            "isUnique": true,
            "type": "TEXT",
            "valueHint": "e.g.: user-logged-in"
          },
          {
            "macrosInSelect": true,
            "defaultValue": "",
            "displayName": "Custom Variable Value",
            "name": "Value",
            "type": "TEXT",
            "valueHint": "Choose a GTM Variable or type some value here"
          }
        ],
        "type": "SIMPLE_TABLE"
      },
      {
        "displayName": "Note: Create your own custom variables. It will be passed to Sklik as additional URL parameters. e.g. user-logged-in with value 1 will be passed as &user-logged-in=1",
        "name": "Explanation",
        "type": "LABEL"
      }
    ]
  }
]


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_pixel",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://c.imedia.cz/retargeting*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Enter your template code here.
const log = require('logToConsole');
const encodeUriComponent = require('encodeUriComponent');
const sendPixel = require('sendPixel');
const getUrl = require('getUrl');
const getType = require('getType');
const query = require('queryPermission');

var url = getUrl();
var rtgId = data.SklikID;
var category = data.seznam_category || '';
var itemId = data.seznam_itemId || '';
var pageType = data.seznam_pagetype || '';
var newQuery = [];

if (getUrl('query').length > 0) { newQuery.push(getUrl('query')); }

for (var customVarRow in data.CustomVarsTable) {
  var customVar = data.CustomVarsTable[customVarRow];
  
  if (getType(customVar.Value) !== 'undefined' || customVar.Value !== '') {
    newQuery.push(customVar.VariableName+'='+customVar.Value);
  }
}

var newURL = url.split('?')[0];
if (newQuery.length > 0) {
  var newURL = newURL + '?' + newQuery.join('&');
}

if (getUrl('fragment').length > 0) {
  newURL = newURL + '#' + getUrl('fragment');
}

var src = "https://c.imedia.cz/retargeting?" + "id=" + rtgId + "&category=" + encodeUriComponent(category) + "&itemId=" + encodeUriComponent(itemId) + "&url=" + encodeUriComponent(newURL);
if (pageType) {src += "&pageType=" + encodeUriComponent(pageType);}

log('data =', data);
log('url = ', url);
log('newURL = ', newURL);
log('output url = ', src);

if (query('send_pixel', src)) {
  sendPixel(src);
}


// Call data.gtmOnSuccess when the tag is finished.
data.gtmOnSuccess();


___NOTES___

Created on 25/09/2019, 16:49:03
