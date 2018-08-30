class wordpress {
    include wordpress::install
    include wordpress::service
    include wordpress::config
}
