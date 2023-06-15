## Node setup

### Wireguard

You need to provide two things: one public key, and an ip address, both need to be added to the file `./hive/flake.nix` to the `networking.wireguard.interfaces.wg0.peers` sections.

#### Generate a key pair

- `wg genkey` (that's your private key, note it down)
- `echo $YOUR_PRIVATE_KEY | wg pubkey` (that's your public key, put that into the flake.nix file)
- add an entry to our [IP address registry](https://docs.google.com/spreadsheets/d/1E4YsUCuU2ez75bOh6kxMwjYjjgna-3vh7K2YFoa6A8g/edit#gid=0), i.e.: choose a free ip from the block 10.0.0.1-10.0.0.254 (i.e.: 10.0.0.0/24) 
  

## IF YOU ALREADY HAVE A NODE RUNNING, UNINSTALL IT VIA /usr/local/bin/k3s-agent-uninstall.sh !!!
#### Configuration

Setup the wireguard configuration. There are multiple ways to do it, this is the `wg-quick` method.         

For that, you will need to create /etc/wireguard/wg0.conf, replace your IP Address and private key:

```
[Interface]
PrivateKey = $YOUR_PRIVATE_KEY
ListenPort = 51820
Address    = 10.0.0.$YOUR_IP_ADDRESS/32

[Peer]  
PublicKey = 60dVYunQRvc55FxMoOdnu9vqSl8Rb4FXAnpUNiyR7i4=
AllowedIPs = 10.0.0.1/24
Endpoint = 167.235.131.220:51820       
```

Then you do 
```
$ wg-quick up wg0
```

and wireguard will create routing entries etc for you. _After_ pinging 10.0.0.1 the connection should be established, which you can verify by

```
root@rpi3:~# wg show
interface: wg0
  public key: qw5tOwhHyHdKqWNv6ReVl7U4SIAY2Zt8vAJd5H8q/XY=
  private key: (hidden)
  listening port: 51820

peer: 60dVYunQRvc55FxMoOdnu9vqSl8Rb4FXAnpUNiyR7i4=
  endpoint: 167.235.131.220:51820
  allowed ips: 10.0.0.0/12
  latest handshake: 1 minute, 29 seconds ago
  transfer: 1.43 MiB received, 7.18 MiB sent
```


#### Checkpoint

- you should be able to ping 10.0.0.1
- you should be able to ping any other node (look at the sheet to find available node ips, the kenny, phillip and bebe* nodes should be up most of the time)
          
#### Pitfalls

- AllowedIps should have netmask `24`.
- make sure the port is really `51820` — avoid twisted numbers ;)

**Don't move on beyond this point** if you can't ping other nodes. We noticed that re-configuring wireguard AFTER k3s/flannel uses the interface for it's connection requires at least a restart of k3s, if not a reboot of the machine.              

## K3s

## Installscript
                         
### required data

- get the master-token from our teams-chat
- to execute kubectl/k9s, get the k3s.yaml file from teams-chat

```
curl -sfL https://get.k3s.io | K3S_URL="https://node0.kooperative.cloud:6443" K3S_TOKEN="$MASTER_TOKEN" INSTALL_K3S_EXEC="--flannel-iface wg0" sh -
```

## Firewall

- make sure [port 8472/udp is open (for flanel/VXLAN)](https://docs.k3s.io/installation/requirements#networking)
- also, port 10250/tcp should be open. This one is way easier to detect/debug ;)
                           
#### Pitfalls

- make sure to add `--flannel-iface wg0`, otherwise k3s/flannel tends to choose your default ethernet-interface/default ipv4 address

#### checkpoint

- your node should show up here: `KUBECONFIG=~/k3s.yaml kubectl get nodes`
- the internal and external ip address of your node should match the wg0-ip-address: `KUBECONFIG=~/k3s.yaml kubectl describe node $MY_NODE_NAME`
- run a shell and ping other pods: `KUBECONFIG=~/k3s.yaml kubectl run test-my-node --rm -i --tty --image wbitt/network-multitool --overrides='{"spec": { "nodeSelector": {"kubernetes.io/hostname": "$MY_NODE_NAME"}}}' -- bash`

## Grafana dashboards

We set up some Grafana dashboards to report on the state of the cluster.  We did this by using Helm to install
Victoria Metrics, which (unlike other installation methods) installs all the components needed, including Prometheus Node Exporter
and Grafana, and sets up the dashboards for us.

To install, follow the instructions [here](https://github.com/VictoriaMetrics/helm-charts/blob/master/charts/victoria-metrics-k8s-stack/README.md).
In particular, install Helm the way the link indicates; trying to shortcut the process and installing Helm via `snap` leads to an incompatible
version which can't handle the Helm chart involved.

The [Helm chart provided](https://github.com/VictoriaMetrics/helm-charts/blob/master/charts/victoria-metrics-k8s-stack/values.yaml) needed a little tweaking for our purposes; the config file in question may be found in `modules/victoriametrics/values.yaml`.


