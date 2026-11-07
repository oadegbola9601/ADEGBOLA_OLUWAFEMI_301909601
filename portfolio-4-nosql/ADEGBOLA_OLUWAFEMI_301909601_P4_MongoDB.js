// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("pos_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("pos_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "sale_created",
                    "line_added"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "sale_line"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "line_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("pos_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "sale_created",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "sale_line",
            "key": {
                "line_id": 4
            },
            "snapshot": {
                "line_id": 4,
                "sale_id": 3,
                "product_id": 2,
                "quantity": 2,
                "unit_price": 12.5
            }
        },
        "embedded": {
            "product": [
                {
                    "key": {
                        "product_id": 2
                    },
                    "snapshot": {
                        "product_id": 2,
                        "sku": "SKU-001",
                        "product_name": "Canvas Tote",
                        "unit_price": 12.5,
                        "active": true
                    },
                    "via": [
                        "sale_line.product_id → product"
                    ]
                }
            ]
        },
        "references": {
            "sale": [
                {
                    "key": {
                        "sale_id": 3
                    },
                    "via": [
                        "sale_line.sale_id → sale"
                    ]
                }
            ],
            "store": [
                {
                    "key": {
                        "store_id": 1
                    },
                    "via": [
                        "sale_line.sale_id → sale.store_id → store"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "line_added",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "sale_line",
            "key": {
                "line_id": 4
            },
            "snapshot": {
                "line_id": 4,
                "sale_id": 3,
                "product_id": 2,
                "quantity": 2,
                "unit_price": 12.5
            }
        },
        "embedded": {
            "product": [
                {
                    "key": {
                        "product_id": 2
                    },
                    "snapshot": {
                        "product_id": 2,
                        "sku": "SKU-001",
                        "product_name": "Canvas Tote",
                        "unit_price": 12.5,
                        "active": true
                    },
                    "via": [
                        "sale_line.product_id → product"
                    ]
                }
            ]
        },
        "references": {
            "sale": [
                {
                    "key": {
                        "sale_id": 3
                    },
                    "via": [
                        "sale_line.sale_id → sale"
                    ]
                }
            ],
            "store": [
                {
                    "key": {
                        "store_id": 1
                    },
                    "via": [
                        "sale_line.sale_id → sale.store_id → store"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "terminal_id": "illustrative terminal_id",
                "promotion_code": "illustrative promotion_code",
                "payment_reference": "illustrative payment_reference"
            }
        }
    }
]));
  await db.getCollection("pos_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("pos_events").find({"eventType":"sale_created"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("pos_events").find({"source.key.line_id":4}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("pos_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("pos_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("pos_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "sale_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "sale_line",
        "key": {
            "line_id": 4
        },
        "snapshot": {
            "line_id": 4,
            "sale_id": 3,
            "product_id": 2,
            "quantity": 2,
            "unit_price": 12.5
        }
    },
    "embedded": {
        "product": [
            {
                "key": {
                    "product_id": 2
                },
                "snapshot": {
                    "product_id": 2,
                    "sku": "SKU-001",
                    "product_name": "Canvas Tote",
                    "unit_price": 12.5,
                    "active": true
                },
                "via": [
                    "sale_line.product_id → product"
                ]
            }
        ]
    },
    "references": {
        "sale": [
            {
                "key": {
                    "sale_id": 3
                },
                "via": [
                    "sale_line.sale_id → sale"
                ]
            }
        ],
        "store": [
            {
                "key": {
                    "store_id": 1
                },
                "via": [
                    "sale_line.sale_id → sale.store_id → store"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("pos_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "sale_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "sale_line",
        "key": {
            "line_id": 4
        },
        "snapshot": {
            "line_id": 4,
            "sale_id": 3,
            "product_id": 2,
            "quantity": 2,
            "unit_price": 12.5
        }
    },
    "embedded": {
        "product": [
            {
                "key": {
                    "product_id": 2
                },
                "snapshot": {
                    "product_id": 2,
                    "sku": "SKU-001",
                    "product_name": "Canvas Tote",
                    "unit_price": 12.5,
                    "active": true
                },
                "via": [
                    "sale_line.product_id → product"
                ]
            }
        ]
    },
    "references": {
        "sale": [
            {
                "key": {
                    "sale_id": 3
                },
                "via": [
                    "sale_line.sale_id → sale"
                ]
            }
        ],
        "store": [
            {
                "key": {
                    "store_id": 1
                },
                "via": [
                    "sale_line.sale_id → sale.store_id → store"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("pos_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
