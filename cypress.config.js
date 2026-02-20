
const { defineConfig } = require('cypress')

module.exports = defineConfig({
  video: false,

  e2e: {
    baseUrl: 'http://localhost:4200',
    experimentalRunAllSpecs: true
  },

  reporter: 'mochawesome',
  reporterOptions: {
    reportDir: "cypress/reports",
    overwrite: false,
    html: true,
    json: true,
  },

  component: {
    devServer: {
      framework: 'angular',
      bundler: 'webpack',
    },
    specPattern: '**/*.cy.ts'
  }
})
