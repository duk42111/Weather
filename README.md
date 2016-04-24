# Weather

Solution goes a bit further from Specs in following:
- full wrapper as networking artefact
- presenting fully clean code combining MVVM with busines logic object
- written in Swift that is not my first language

There wasn't much consideration about visual representation of data, however, the retrieved data was left in raw form that allows adaptation to any perspective of presenting data. This has made busines logic a bit more complicated, but in reality it would be better adapted to actual presentation dimension. This time simple table view with section was selected, it could be combination of collection views and table views or practically anything.

Tests wer made just for taste. There are also no UI Tests.

There are many code smells here and I'll be happy to discuss it further.
