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

Positions = new Meteor.Collection "positions"

if Meteor.isClient
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
            return playerMap[Session.get("name")].find({});
        playerMap["overall"].find({});
    
    Template.dropdown.positions = () ->
        return Positions.find({});
    Template.dropdown.events = 
        'click li[name]' : (event) ->
            Session.set('name', $(this).attr('name'));
    Handlebars.registerHelper 'sessionValue', (input)->
        return Session.get(input);


if (Meteor.isServer) 
    Meteor.startup () -> 
        catchers = Catchers.find({});
        catchers.forEach (catcher) ->
            Catchers.remove({_id : catcher._id});
        overall = Overall.find({});
        Overall.remove({_id : overall._id});
        positions = Positions.find {}
        positions.forEach (pos)->
            Positions.remove({_id : pos._id});
        
        if (Catchers.find().count() == 0) 
            Catchers.insert({name : "Buster Posey", positions : [ 'C', '1B' ], positionRank : [1, 5], overallRank : 25 , snippet : "Posey is entering his fourth season in the majors and he already has a Rookie of the Year award (2010), Comeback Player of the Year award (2012), and MVP award (2012). What happened in 2011?  Oh, he just broke his leg in May and missed the rest of the season.  Posey hits for both power and average and also has a very good walk rate. He doesn’t just have the skill set, he also has the benefit of playing some first base which gives him more at-bats than your regular catcher. But then again, Posey isn’t your regular catcher.", stats : [{ year : 2010,  g : 108, pa : 443, r : 58, hr : 18, rbi : 67, sb : 0, babip : .315, ba : .305, ld : 18.4, fb : 33.1, hrPerFB : 15.4, iso : .200, psr : 3.35, psrRank : 118, xbabip : .319, xba : .302 }, { year : 2011,  g : 45, pa : 185, r : 17, hr : 4, rbi : 21, sb : 3, babip : .326, ba : .284, ld : 18, fb : 29.3, hrPerFB : 10.3, iso : .105, psr : -2.43, psrRank : 605, xbabip : .295, xba : .260 }, { year : 2012, g : 148, pa : 610, r : 78, hr : 24, rbi : 103, sb : 1, babip : .368, ba : .336, ld : 24.6, fb : 28.9, hrPerFB : 18.8, iso : .213, psr : 8.76, psrRank : 11, xbabip : .374, xba : .351}, { year : 2013, g : 149, pa : 616, r : 81, hr : 25, rbi : 100, sb : 2, babip : .346, ba : .316, ld: 22, fb : 29.1, hrPerFB : 19.1, iso : .217, psr : 7.76, psrRank : 25, xbabip : .346, xba : .316 }]});
            Catchers.insert({name : "Joe Mauer", positions : [ 'C', '1B'], positionRank : [2, 14], overallRank : 74, snippet : "When presenting the following numbers we’re just going to toss Mauer’s 2011 out the window. He was hurt and it could happen again. He’s scored 80+ runs in each of his last four healthy seasons, driven in 85+ in three of them, hit either 9 or 10 homers in three of them (and 28 that one year, wtf?), and batted at least .319 in all four.  Cumulatively that means we’re looking at a projected line around 80 runs, 10 homers, 85 RBI, and a .320 average. This comes pretty close to our projection. When healthy, he’s as consistent as they come." });
            setOverall(Catchers);
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
    
setOverall = (collection)-> 
    values = collection.find();
    count = 1;
    values.forEach (value) ->
        Overall.insert(value)
    
    