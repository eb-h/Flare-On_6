from scapy.all import *
import socket
import struct
from collections import OrderedDict

packets = rdpcap('capture.pcap')

total = []
for index, pkt in enumerate(packets):
	if pkt.haslayer(DNS):
		if pkt['DNS'].qr == 0:
			p = OrderedDict()
			p = {'player move': str(pkt["DNS Question Record"].qname)}
		else:  # == 1
			ip = str(pkt["DNS Resource Record"].rdata)
			packed_ip = socket.inet_aton(ip)
			unpacked_ip = struct.unpack('<BBBB', packed_ip)

			p['move_counter'] =  int(unpacked_ip[2]) & 0xf
			#p['ai_piece'] = int(unpacked_ip[2]) >> 4
			#p['ai_moved_to'] = int(unpacked_ip[3]) >> 1
			p['to_return'] = unpacked_ip[3] >> 7

			chksum = int(unpacked_ip[3]) & 1 == 0

			unpacked_ip = [str(x) for x in unpacked_ip]
			p['IP returned'] = '.'.join(unpacked_ip)

			if chksum:
				total.append(p)

total = sorted(total, key=lambda i: i['move_counter'])

for pkt in total:
	#if (pkt['to_return'] == 0 and pkt['move_counter'] != 0x13) or pkt['move_counter'] >= 0x13:
		print('')
		for k,v in pkt.items():
			print(k, v)
