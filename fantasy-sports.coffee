Catchers = new Meteor.Collection "catchers"
FirstBase = new Meteor.Collection "first"
SecondBase = new Meteor.Collection "second"
Shortstop = new Meteor.Collection "shortstop"
ThirdBase = new Meteor.Collection "third"
Outfield = new Meteor.Collection "outfield"
Starting = new Meteor.Collection "starting"
Relief = new Meteor.Collection "relief"
Overall = new Meteor.Collection "overall"
Position = new Meteor.Collection "position"
Pitchers = new Meteor.Collection "pitchers"
Teams = new Meteor.Collection "teams"
Positions = new Meteor.Collection "positions"

okCancelEvents = (selector, callbacks) -> 
  ok = callbacks?.ok 
  cancel = callbacks?.cancel 
  events = {};
  events['keyup '+selector+', keydown '+selector+', focusout '+selector] =
    (evt) ->
      if (evt.type == "keydown" && evt.which == 27) 
        # escape = cancel
        cancel?.call(this, evt);

      else if (evt.type == "keyup" && evt.which == 13 || evt.type == "focusout")
        # blur/return/enter = ok/submit if non-empty
        value = String(evt.target.value || "");
        if (value)
            ok?.call(this, value, evt);
        else
            cancel?.call(this, evt);
  return events;

if Meteor.isClient
    listsHandle = Meteor.subscribe('lists')
    Template.teams.loading =  () ->
        return !teamsHandle.ready();
    Template.teams.teams = () ->
        return Teams.find({}, {sort: {name: 1}});
    Template.teams.events(okCancelEvents(
      '#new-team',{
          ok: (text, evt)->
            id = Teams.insert({name: text});
      }
    ));
    $(document).ready ->
        $('body').delegate '.playerPopover', 'click' , (event)->
            if $(this).data('playerPopover')
                return true
            $(this).popover
                html:true
                trigger:'click'
                placement: 'bottom'
                content : ->    
                    return $(this).find('.playerInfo').html()
            $(this).data('playerPopover', true)
            $(this).popover('show')
        
    Session.setDefault 'name', 'Overall'
    playerMap = 
        "Overall" : Overall
        "Catchers" : Catchers
        "First Base" : FirstBase
        "Second Base" : SecondBase
        "Shortstop" : Shortstop
        "Third Base" : ThirdBase
        "Outfield" : Outfield
        "Starting Pitchers" : Starting
        "Relief Pitchers" : Relief
        "Position Players" : Position
        "All Pitchers" : Pitchers
    Template.listing.players = () ->
        if (playerMap[Session.get("name")]) 
            return playerMap[Session.get("name")].find({}, {sort : {overallRank : 1}});
        playerMap["overall"].find({}, {sort : {overallRank : 1}});
    
    Template.dropdown.positions = () ->
        return Positions.find({});
    Template.dropdown.events = 
        'click li[name]' : (event) ->
            Session.set('name', $(this).attr('name'));
    Handlebars.registerHelper 'sessionValue', (input)->
        return Session.get(input);
    
if (Meteor.isServer) 
    Meteor.startup () -> 
        if (Positions.find().count() == 0) 
            Positions.insert({ name : "Overall", subMenu : [ {text : "All Players", name : "Overall" } , { text : "Position Players", name : "Position Players" }, { text : "Pitchers",  name : "All Pitchers" } ]}  );
            Positions.insert({ name : "Catchers", text : "C", addToCollections : [ "Overall", "position", "catchers" ] });
            Positions.insert({ name : "First Base", text : "1B", addToCollections : [ "Overall", "position", "first" ]});
            Positions.insert({ name : "Second Base", text : "2B", addToCollections : [ "Overall", "position", "second"  ]});
            Positions.insert({ name : "Shortstop", text : "SS", addToCollections : [ "Overall", "position", "shortstop" ]});
            Positions.insert({ name : "Third Base", text : "3B", addToCollections : [ "Overall", "position", "third" ]});
            Positions.insert({ name : "Outfield", text : "OF", addToCollections : [ "Overall", "position", "outfield" ] });
            Positions.insert({ name : "Starting Pitchers", text : "SP", addToCollections : [ "Overall", "starting", "pitchers"  ]});
            Positions.insert({ name : "Relief Pitchers", text : "RP", addToCollections : [ "Overall", "relief", "pitchers" ] });
