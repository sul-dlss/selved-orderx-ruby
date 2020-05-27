# selved-wrapper-ruby

This package is intended to be used with the Symphony selved_orderx.sh script and called in that script as
such:
```
$DIR/selved-wrapper-ruby/current/selved_return_allinput.rb $DIR/order_keys.txt $DIR/selved_data.txt
```
where `$DIR` is the deployment directory `/s/SUL/Bin/SelvedWrapper`.

The script takes in two filename arguments: a file of order keys, and the order keys run through `selved`.

```
result = ReturnAllInput.new
result.update_hash(ARGV[0])
result.pipe_hash(ARGV[1])
```

The output:
```
4039382||
4091827||
4048122||
4107565||
4122803||
4124137||
4124279||
4122596||
4109500|BIGDEAL: This is a big deal, MULTIYEAR: 2018 to present, DATA: This is data, STREAMING: This is streaming|
4345863|BIGDEAL: Test Bigdeal|
``` 
