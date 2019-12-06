
import json, hashlib, sys
from smartcards.core import CardInterface

import time
time.sleep(2)

f = open(sys.argv[1])
trustee_data = json.loads(f.read())
f.close()

trustee_json_bytes = json.dumps(trustee_data).encode('utf-8')
short_value = json.dumps({'t':'trustee', 'h': hashlib.sha256(trustee_json_bytes).hexdigest()})

print(CardInterface.card)
CardInterface.override_protection()
CardInterface.write_short_and_long(short_value.encode('utf-8'), trustee_json_bytes)

print("done")
