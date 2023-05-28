import os, sys
cur_dir = os.path.dirname(os.path.abspath(__file__))
proto_path = os.path.abspath(os.path.join(cur_dir, '../protobuf_def'))
sys.path.append(proto_path)
