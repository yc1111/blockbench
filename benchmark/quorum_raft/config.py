NODES=['10.0.0.{}'.format(x) for x in range(3,13)]
partition_cmd = './partition.sh {} {} {} &'
TIMEOUT=150
