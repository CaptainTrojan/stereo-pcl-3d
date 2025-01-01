import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np

# Extract points and bounding boxes
# pts = data_input['points']
# pred_3d_boxes = pred_data_3d['bboxes_3d']
# gt_3d_boxes = data_sample.eval_ann_info['gt_bboxes_3d']
pts = np.random.rand(100, 4)
pred_3d_boxes = np.array([[ 3.4309, -2.4137, -1.7450,  3.0800,  1.4400,  1.3900, -0.0808],
        [10.7088,  2.2264, -1.5699,  3.6600,  1.6000,  1.4700, -0.0808],
        [30.4694,  0.8002, -1.4984,  4.0800,  1.6300,  1.7000,  2.9924],
        [17.7711, -3.6211, -1.6779,  2.4700,  1.5900,  1.5900, -0.0808],
        [44.9218, -2.7453, -1.6149,  1.1900,  0.5500,  1.8100,  3.0524],
        [22.5918, -4.2096, -1.7137,  3.2200,  1.5900,  1.3700, -0.1308]])
gt_3d_boxes = np.array([[-1.4570681e+01,  5.1036251e+01, -8.8412361e+00,  3.0992507e+03,
         3.7944224e-01,  2.3123348e+01, -1.9384060e+00],
       [-1.4404078e+01,  4.9620079e+01, -8.6525402e+00,  3.0071042e+03,
         3.6093313e-01,  2.1303295e+01, -2.0326228e+00],
       [-1.4399460e+01,  5.2327927e+01, -8.7085581e+00,  2.2846353e+03,
         4.1146162e-01,  2.2769541e+01, -1.9658856e+00],
       [-1.4171553e+01,  4.8217457e+01, -8.4836159e+00,  2.6161729e+03,
         3.5097241e-01,  1.9792213e+01, -2.1004701e+00],
       [-5.1972942e+00,  4.8911503e+01, -3.4708237e+01,  5.1069183e+00,
         6.3438691e-02,  1.3268977e-01, -3.0440261e+00],
       [-4.9974160e+00,  4.7636860e+01, -3.4353394e+01,  4.7293563e+00,
         6.5288991e-02,  1.3298102e-01, -5.6926250e-02],
       [-9.8008575e+00,  5.1636154e+01, -1.0528511e+01,  3.4201649e+01,
         4.6642189e+01,  1.4618255e-01, -1.5348587e+00],
       [ 1.0662668e+01,  3.5237404e+01,  1.1638756e+00,  2.8847539e+00,
         4.2647114e+00,  2.7345398e-01, -7.2336483e-01],
       [ 7.5801811e+00,  3.7603146e+01,  1.1829576e+00,  3.1331823e+00,
         2.7788017e+00,  2.9620504e-01, -1.4984250e+00],
       [ 9.0443363e+00,  3.1292591e+01,  1.1240020e+00,  2.9605567e+00,
         3.2624753e+00,  3.2247284e-01, -1.5282860e+00],
       [-1.3219555e+01,  2.7796045e+01,  6.0005140e-01,  5.8775530e+00,
         3.1751379e-01,  3.5956550e+00, -6.3996315e-02],
       [-1.2879513e+01,  2.6775730e+01,  5.2593112e-01,  5.8757844e+00,
         3.2890859e-01,  3.2892787e+00, -3.1062486e+00],
       [-1.3067587e+01,  2.9194719e+01,  6.3695621e-01,  5.7068810e+00,
         3.1776536e-01,  3.7639692e+00, -8.3265781e-02],
       [-1.2479511e+01,  2.5815136e+01,  4.3954265e-01,  5.7870817e+00,
         3.4059906e-01,  3.1077690e+00, -3.0278664e+00],
       [-1.2146002e+01,  2.5028854e+01,  3.4372520e-01,  5.5731502e+00,
         3.6441103e-01,  2.9718406e+00, -2.9872856e+00]])

# Function to convert a bounding box to its corner points
def bbox_to_corners(bbox):
    x, y, z, dx, dy, dz, yaw = bbox
    corners = np.array([
        [dx / 2, dy / 2, dz / 2],
        [-dx / 2, dy / 2, dz / 2],
        [-dx / 2, -dy / 2, dz / 2],
        [dx / 2, -dy / 2, dz / 2],
        [dx / 2, dy / 2, -dz / 2],
        [-dx / 2, dy / 2, -dz / 2],
        [-dx / 2, -dy / 2, -dz / 2],
        [dx / 2, -dy / 2, -dz / 2]
    ])
    # rotation_matrix = np.array([
    #     [np.cos(yaw), -np.sin(yaw), 0],
    #     [np.sin(yaw), np.cos(yaw), 0],
    #     [0, 0, 1]
    # ])
    rotation_matrix = np.eye(3)
    corners = np.dot(corners, rotation_matrix.T)
    corners += np.array([x, y, z])
    return corners

# Function to plot 3D bounding boxes
def plot_bbox(ax, bbox, color):
    corners = bbox_to_corners(bbox)
    edges = [
        [corners[0], corners[1], corners[2], corners[3], corners[0]],
        [corners[4], corners[5], corners[6], corners[7], corners[4]],
        [corners[0], corners[4]],
        [corners[1], corners[5]],
        [corners[2], corners[6]],
        [corners[3], corners[7]]
    ]
    for edge in edges:
        ax.plot3D(*zip(*edge), color=color)

def set_axes_equal(ax):
    """Set 3D plot axes to equal scale."""
    limits = np.array([
        ax.get_xlim3d(),
        ax.get_ylim3d(),
        ax.get_zlim3d(),
    ])
    origin = np.mean(limits, axis=1)
    radius = 0.5 * np.max(np.abs(limits[:, 1] - limits[:, 0]))
    ax.set_xlim3d([origin[0] - radius, origin[0] + radius])
    ax.set_ylim3d([origin[1] - radius, origin[1] + radius])
    ax.set_zlim3d([origin[2] - radius, origin[2] + radius])

# Create a figure and a 3D axis
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Plot the points
# ax.scatter(pts[:, 0], pts[:, 1], pts[:, 2], c='b', marker='o', s=1, label='Points')

# Plot predicted 3D bounding boxes
for bbox in pred_3d_boxes:
    plot_bbox(ax, bbox, 'r')

# Plot ground truth 3D bounding boxes
# for bbox in gt_3d_boxes:
#     plot_bbox(ax, bbox, 'g')

# Set labels
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')
set_axes_equal(ax)

# Save the plot to a file
plt.savefig('frame.png')
plt.close()