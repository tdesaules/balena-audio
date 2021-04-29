#!/usr/bin/env node

var bonjour = require('bonjour')()

// advertise an HTTP server on port 3000
bonjour.publish({ name: 'Mopidy', type: 'http', port: 8080, host: 'mopidy-chambre.local' })