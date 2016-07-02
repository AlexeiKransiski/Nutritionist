class App.Views.Main.Page extends Null.Views.BasePage

  initialize: (opts) =>
    super

    @left_bar = new App.Views.Main.LeftBar
    # load contact invitations on the top right menu dropdown
    #@invitations = new App.Views.IM.Contacts.Invitations()



  render: () =>
    # roster left item
    @addView @left_bar.render(), "[data-role=left-bar]"

    # top bar invitations dropdown
    # @addView @invitations.render(), 'ul[data-role=check-invitations]'
