# ZSSN (Zombie Survival Social Network)

This is a programming test based on https://gist.github.com/raphapizzi/b1f4a84a1f19ffcffa5310dc0773b0ff

(I named it Zombie - Survivor Relationship Manager, because I think it makes more sense)

## Setting up
#### Clone this repository
`git clone https://github.com/fedeaux/zombie-srm.git`
`cd zombie-srm`

#### Setup the database
`rake db:setup` # Be sure to have a postgresql server running on localhost without a password
`rake db:migrate` # create the tables
`rake db:seed` # put some dummy data, params can be adjusted at `db/seeds/survivors.seeds.rb`

## API
### Survivors
#### Create a survivor with resources

```
POST /api/v1/survivors
params example:

{
  "survivor": {
    "name": "Edson Arantes do Nascimento" # String
    "age": 63 # Integer
    "gender": "male" # String, allowed: "male", "female"
    "latitude": -22.9329 # Float
    "longitude": -47.0738 # float
    "water": 2 # Integer
    "food": 4 # Integer
    "medication": 5 # Integer
    "ammunition": 4 # Integer
  }
}

The reponse will be just the same parameters given back or an error message.
```

All fields are optional because it might be hard to get all information from suspicious survivors (They don't usually share information)

Specs can be found at `specs/requests/api/v1/survivors_spec.rb`

#### Update a survivor's location

```
PUT /api/v1/survivors/:survivor_id
params example:

{
  "survivor": {
    "latitude": -22.9329 # Float
    "longitude": -47.0738 # float
  }
}

```

Specs can be found at `specs/requests/api/v1/survivors_spec.rb`

### Infection Marks
#### Create an Infection Mark

```
PUT /api/v1/infection_marks
params example:

{
  "infection_mark": {
    "from_id": 1 # The survivor id that is reporting the mark
    "to_id": 2 # The survivor id that is receiving the report
  }
}

The reponse will be just the same parameters given back or an error message
```

##### Restrictions
* A survivor that gets three or more infection marks is marked as infected and won't be able to perform trades (see below).
* The same survivor can't report other survivor more than once.
* A survivor can't report itself (from_id must be different than to_id)
* An infected survivor can report other survivors as infected, but zombies usually don't play well with technology, so we are probably fine.

Specs can be found at `specs/requests/api/v1/infection_marks_spec.rb` and `specs/models/infection_mark_spec.rb`

### Trades

#### Register a Trade
```
POST /api/v1/trades
params example:

  {
    trade: [
      {
        survivor_id: 1,
        # Resources given by user 1
        water: 2
      },
      {
        survivor_id: 2,
        # Resources given by user 2
        food: 1,
        medication: 2,
        ammunition: 1
      }
    ]
  }

Example responses
{ "status": "success" }
{ "status": "error", message: "Some error message"}
```

##### Restrictions
* Infected survivors can't be part of trades.
* A survivor can't offer more than what it has in it's resources.
* A survivor can't trade with itself.
* Trades must obey the points balance rule as described in the original challenge.
* Duplicate entries for resources (within the same side of the trade) are considered a bad request and it's behaviour is unpredicted (would work on that with more time)

### Reports

To get reports:
```
GET /api/v1/reports

# example response:

{
  "infected_percentage": "20.2%",
  "survivors_percentage": "79.8%",
  "average_resources_per_survivor": {
    "water": 5.11,
    "food": 4.8,
    "medication": 4.8,
    "ammunition": 9.94
  },
  "lost_points_to_infected": 11130
}

```

## Adding a new resource type.
For example, if you want to add a survivor resource named "magic_items" you'd have to:
- Add it to Survivor::RESOURCES
- Add to permitted params at Api::V1::SurvivorsController#survivor_params
- Add to the particular view at app/views/api/v1/survivors/_show.jbuilder
- Trades and reports will work without any further change
