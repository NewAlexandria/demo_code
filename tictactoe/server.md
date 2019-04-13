# a review of the spec

The User model could be “xUser”/“oUser” instead of  “xUser”/“yUser”.  This would better reflect the real semantics, both of business and the user.
Coordinate could take an input from the `GameRequest::UserCriteria`, for the row/col maximums, to allow larger board sizes.

User creation could include a `symbol` field, as a single utf8 character, such as an emoji. This could passthrough to the Symbol enum in Game, allowing characters to play a more personalized game.	
`PUT /gameRequests/{uuid}/game` may make more sense at
`PUT /games/{uuid}/new`

`POST /accessTokens` would follow convention if it were
`POST /users/{uuid}/accessTokens`

All ‘Matching’ and ‘Play’ endpoints need to take an accessToken string as a parameter.


? Win condition


- architecture / infrastructure design
- a plan for staffing and execution


in:  https://app.swaggerhub.com/apis/evenfinancial/tic-tac_toe_api/0.0.1

out:https://app2.greenhouse.io/tests/8e7071b8271180771fc791fc55fcb6ef


## A review of the spec
The User model could be “xUser”/“oUser” instead of “xUser”/“yUser”. This would better reflect the real semantics, both of business and the user.
All ‘Matchingʼ and ‘Playʼ endpoints need to take an accessToken string as a parameter, or as a header. This is not specified. aAlternatively, see the architectural section, below)

If a game is already won, then / games/{uuid}/moves could return 403 Forbidden to be more explicit.

`PUT /gameRequests/{uuid}/game` may make more sense at
`PUT /games/{uuid}/new`
`POST /accessTokens would`

follow convention if it were
POST /users/{uuid}/accessTokens
Coordinate could take an input from the GameRequest::UserCriteria, for the row/col maximums, to allow larger board sizes.

User creation could include a `symbol` field, as a single utf8 character, such as an emoji. This could passthrough to the Symbol enum in Game, allowing characters to play a more personalized game.
Architecture / infrastructure design

### A few basic structures:
* Auth service, public access. Proxy router
* Game server Database Flat token file

● ●

○ ○ ○

The proxy router is configured to hold, in-memory, all valid tokens. This ensures that traffic to the servers is passed with a separation of responsibilities. No game services need to validate tokens, now or in the future. aThis also follows the exact structure of the API spec, whether that was modeled ideal, or not)
For the sake of some future expansion I have included a ‘flat fileʼ as the read/write point for tokens. A database is not commonly accessed from a proxy router (eg Nginx), due to norms. We could make it access the DB, but reading a config file is a more standard practice. Maintaining the tokens as an in-memory store will minimize the routing delay to less that 10ms. When the size of active sessions sessions becomes large enough to force sharding, then anycasting DNS can be used to enable to the

proxy cluster to remain scalable. If (when) we get to a scale of global routing, and we have sharded routers, we can replicate the proxy routers within reasonable zones for the geographies of our engagement.
With 8 char tokens that use 8bits for 128 characters, the key-space is 7.2e16. A dedicated machine with 8 GiB of memory could hold around 1 billion tokens in memory. Therefore, even a proxy router fully saturated with active sessions would only stand a 1c67 million chance of being guessed, and a brute force attack would be easily identified and blocked by policy. These odds are halved, if we use the anycasting scheme to shard the key-space, rather than acting as a load-balancer.
With 1bn sessions tokens, letʼs presume a long enough timeout

that the servers remain at saturation, a 10% account duplication, and 15% active engagement. We apparently are running a tic-tac-toe server that is in use by 1-in-35 of the worldʼs adult population aexciting!). Game are primarily involve write- operations to the DB. Quickly guessing at about 10k of data per game.
Letʼs assume several segments of engagement that model typical exposure to tictactoe: 1 complete game, 3 complete games, ~12 games awith varied opponents), and 70 games; with percentages [40,40,18,2]. aa135 * 0.4) + aa135 * 0.4) * 3) + aa135 * 0.18)) * 12) + aa135 * 0.02) * 70)) = 5,401,038,200 (5.4 bn) games, or ~50GB of data. Even if we are off by a factor of three on the 10kb data size, we do not have an unmanageable data store. This is easily storable in a single database, even with data growth for new players. The primary ballast in the DB is old games. Old games can be moved to another table or file store, perhaps sharded, for later extraction of analytics (leaderboards, profile stats).

Simultaneous games is the metric that wouldq determine the number of game servers for hosting. If we take the idea of a 3 month surge with 1 week of maximum a4x) load, that is 1.3M each day, with ~5M occurring each day of the spike. With a 20hr spread of active gameplay, a spiked game server could see 4285 active sessions per hour, or 71 each second. Quite modest for a global game-athon, and certainly serviceable via one beefy machine (two for redundancy). We may assume some momentary surges for timezone events (e.g. lunch) of 20x traffic,

1400 requests per second. This is still serviceable by a java application, or 3-5 applications in rails or any other webstack with average tuning.

## A plan for staffing 2nd execution
This was the part of the exercise that made me question if Iʼd thought about it all wrong. This only requires one skilled (architect-level) engineer to setup and operate continuously. To avoid needing such a skilled talent, one (or a few) consultants (e.g. AWS Solutions Architects) could provide core patterns, such as the proxy server and networking. Then a single engineer writes and maintains the applications and data stores.
The game server can be written first, in a lean way to garner beta testing without the

### authentication
Load testing script (jMeter) can help tune the game server and make sure it will scale. Building the auth server is done next, or is done in parallel if consultants are used. Since the auth and proxy routing is independent of the game server, these systems can be built in parallel. Since weʼve contemplated the global popularity of this game, itʼs perhaps reasonable to consider staffing two developers, one for network and ops, and the other for games.

The system will need ops instrumentation to ensure we have a clear picture as it scales. A ticketing system can ensure that we are able to get feedback from users. An alternative like Jiveon could provide both ticketing and community engagement, perhaps more appropriate to a game. Since

this is TicTacToe, and the phenomenon will die off fast, it's important to use off-the-shelf systems so that they can be turned-off easily.

No where in the API specs was there contemplation of monetization. A game that matches this API would typically be monetized through display ads, since there is no topical relationship for performance marketing, nor affiliation. Here too, an existing programmatic or display stack is needed so that it can be disposed of easily, later.

## Refs
in: https://app.swaggerhub.com/ apis/evenfinancial/tic- tac_toe_api/0.0.1 out:https://app2.greenhouse.io/ tests/ 8e7071b8271180771fc791fc55fcb 6ef
            