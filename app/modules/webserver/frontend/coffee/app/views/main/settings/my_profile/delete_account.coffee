class App.Views.Main.Settings.MyProfile.DeleteAccount extends App.Views.Base
  template: JST['app/main/settings/my_profile/delete_account.html']
  className: 'delete_account'
 
  options:
    #tab: '#profile'
    hidden: true

  initialize: (options) =>
    super
    @on 'account:delete', @onDeleteAccount

  events:
    'click [data-role="delete"]': 'onDelete'

  render: () =>
    super

    #@$el.attr 'data-tab', @options.tab
    #@$el.removeClass 'hide' unless @options.hidden

    @

  onDelete: (event)=>
    event.preventDefault()
    console.log "Deleting account"
    modal = new App.Views.Common.DeleteAccountConfirmation(model: app.me) 
    @appendView modal.render(), $("[data-role=modal-container]")
    #(new App.Views.Common.DeleteConfirmation({el: $('[data-role="modal-container"]'), model: app.me})).render()

  onDeleteAccount:()->
    #$.cookies.del('auth_token');
    #$.cookies.del('user');
    #$.cookies.del(true)
    #window.location = '/logout';
    #window.location.reload(); 