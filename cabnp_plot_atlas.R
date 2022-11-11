
# list packages to load
packages <- c("ciftiTools")

# install packages if not yet installed
all_packages <- rownames(installed.packages())
installed_packages <- packages %in% all_packages
if (any(installed_packages == FALSE)){install.packages(packages[!installed_packages])}

# load packages
invisible(lapply(packages, library, character.only = TRUE))
ji_key <- read.table(file.path(project,"CAB-NP/CortexSubcortex_ColeAnticevic_NetPartition_wSubcorGSR_parcels_LR_LabelKey.txt"),header=T)
ji_net_keys <- ji_key[,c("NETWORKKEY","NETWORK")] %>% distinct %>% arrange(NETWORKKEY)
print(ji_net_keys)

# project dir
project <- "~/Dropbox/github/22q_longitudinal/"

# read cifti with subcortical structures labeled 
xii_Ji_parcel <- read_cifti(file.path(project,"CAB-NP/CortexSubcortex_ColeAnticevic_NetPartition_wSubcorGSR_parcels_LR.dscalar.nii"), brainstructures = "all")
xii_Ji_network <- read_cifti(file.path(project,"CAB-NP/CortexSubcortex_ColeAnticevic_NetPartition_wSubcorGSR_netassignments_LR.dscalar.nii"), brainstructures = "all")

# view networks with colors matching original
cabnp_network_colors <- c("#0000FE","#783CEC","#4CFCFC","#B329B2","#02F100","#018E95","#FFFC3D","#F96BFB","#FF320D","#C5784A","#F3A42B","#5D9A18")
view_xifti(xii_Ji_network, colors=cabnp_network_colors, zlim=c(1,12),slices=39,plane="axial")

# networks with representation in thalamus
thal_nets <- xii_Ji_network$data$subcort[which(xii_Ji_network$meta$subcort$labels == "Thalamus-R" | xii_Ji_network$meta$subcort$labels == "Thalamus-L" )] %>% unique %>% sort
# set other networks to grey
cabnp_network_colors_thal <- cabnp_network_colors
cabnp_network_colors_thal[which(!cabnp_network_colors %in% cabnp_network_colors[thal_nets])] <- "lightgrey"

view_xifti(xii_Ji_network, colors=cabnp_network_colors_thal, zlim=c(1,12))

# save surface
view_xifti_surface(xii_Ji_network, fname="~/Dropbox/PhD/conferences/2022_ACNP/poster/cabnp_orig_surf.png", colors=cabnp_network_colors_thal, zlim=c(1,12))

# get version of subcortex with only thalamus networks visualized
xii_Ji_network_sc_thal_mask <- xii_Ji_network
non_thal_inds <- which(xii_Ji_network_sc_thal_mask$meta$subcort$labels != "Thalamus-R" & xii_Ji_network_sc_thal_mask$meta$subcort$labels != "Thalamus-L" )
xii_Ji_network_sc_thal_mask$data$subcort[non_thal_inds] <- 0
view_xifti_volume(xii_Ji_network_sc_thal_mask, fname="~/Dropbox/PhD/conferences/2022_ACNP/poster/cabnp_orig_vol.png", plane="axial",slices=c(39), colors=c("grey",cabnp_network_colors), zlim=c(0,12))

# view only FPN or SOM
cabnp_network_colors_fpn <- c("grey60","grey60","grey60","grey60","grey60","grey60","#FFFC3D","grey60","grey60","grey60","grey60","grey60")
cabnp_network_colors_som <- c("grey60","grey60","#4CFCFC","grey60","grey60","grey60","grey60","grey60","grey60","grey60","grey60","grey60")

view_xifti_surface(xii_Ji_network_sc_thal_mask, fname="~/Dropbox/PhD/conferences/2022_ACNP/poster/cabnp_fpn_surf.png",colors=c("grey",cabnp_network_colors_fpn), zlim=c(0,12) )
view_xifti_volume(xii_Ji_network_sc_thal_mask,fname="~/Dropbox/PhD/conferences/2022_ACNP/poster/cabnp_fpn_thal_vol.png", plane="axial",slices=c(43),bg="white", colors=c("grey",cabnp_network_colors_fpn), zlim=c(0,12) )

view_xifti_surface(xii_Ji_network_sc_thal_mask, fname="~/Dropbox/PhD/conferences/2022_ACNP/poster/cabnp_som_surf.png",colors=c("grey",cabnp_network_colors_som), zlim=c(0,12) )
view_xifti_volume(xii_Ji_network_sc_thal_mask,fname="~/Dropbox/PhD/conferences/2022_ACNP/poster/cabnp_som_thal_vol.png", plane="axial",slices=c(39),bg="white", colors=c("grey",cabnp_network_colors_som), zlim=c(0,12) )



