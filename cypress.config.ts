import { defineConfig } from 'cypress'

export default defineConfig({
  video: false,
  e2e: {
    'baseUrl': 'http://localhost:4200',
    'experimentalRunAllSpecs': true,
    tsConfig: 'tsconfig.cypress.json'
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
    specPattern: '**/*.cy.ts',
    tsConfig: 'tsconfig.cypress.json'
  }
  
})