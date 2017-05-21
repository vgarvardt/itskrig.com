Unmarshal JSON Number to string field in Go
21 May 17 13:07 +0200
golang, kb, knowledge base, json

+++

As Go is strictly-typed language you have to deal with types very carefully and use proper types, e.g. `database/sql.NullString` instead of `string` to deal with DB mapping in correct way. Same applies to unmarshalling JSON-strings (bytes array), especially when you're not controlling JSON-producer or can not change the system that provides JSON-payload. This can be, for example, PHP-application that generates some events as messages to Messaging Queue System like RabbitMQ and writes integer value into the field where your go-application expects string. I faced problem like this a while ago and had to develop some workaround solution in go-application as it was very to hard to change message producer.

First I tried to search the solution on StackOverflow and found couple that I do not like, so I implemented the following:

```go
package main

import (
	"encoding/json"
	"fmt"
	"strconv"
)

type User struct {
	ID       int    `json:"id"`
	StrValue string `json:"str_value"`
}

func (u *User) String() string {
	return fmt.Sprintf("User{ID: %d, StrValue: \"%s\"}", u.ID, u.StrValue)
}

type msgUserIntVal struct {
	*User
	StrValue int `json:"str_value"`
}

func unmarshalUserData(payload []byte) (*User, error) {
	var user User

	err := json.Unmarshal(payload, &user)
	if errType, ok := err.(*json.UnmarshalTypeError); ok {
		if errType.Field == "str_value" && errType.Value == "number" {
			var msgUser msgUserIntVal
			err = json.Unmarshal(payload, &msgUser)
			if nil == err {
				msgUser.User.StrValue = strconv.Itoa(msgUser.StrValue)
				user = *msgUser.User
			}
		}
	}

	return &user, nil
}

func main() {
	payloadStr := []byte(`{"id":10,"str_value":"10"}`)
	payloadInt := []byte(`{"id":10,"str_value":10}`)
	
	if user, err := unmarshalUserData(payloadStr); err != nil {
		fmt.Printf("Unmarshalling from string value failed: %s\n", err)
	} else {
		fmt.Printf("Unmarshalled from string value: %v\n", user)
	}
	
	if user, err := unmarshalUserData(payloadInt); err != nil {
		fmt.Printf("Unmarshalling from int value failed: %s\n", err)
	} else {
		fmt.Printf("Unmarshalled from int value: %v\n", user)
	}
}
```

[The Go Playground](https://play.golang.org/p/UF13xtcOTa)
