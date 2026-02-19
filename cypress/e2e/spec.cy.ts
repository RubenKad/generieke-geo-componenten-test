describe('Simple Test', () => {
  it('Visits the initial project page', () => {
    cy.visit('/')
    cy.contains('map-angular app is running!')
  })

  it('Read the terminal', () => {
    cy.visit('/')
    cy.get('div.terminal').children('pre').should('have.text', 'ng generate component xyz');
  })
})
