<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="Onni.User.ProductDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="product-details spad">
        <div class="container">
            <!-- Хлебные крошки -->
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb bg-white px-0">
                    <li class="breadcrumb-item"><a href="Default.aspx">Главная</a></li>
                    <li class="breadcrumb-item"><a href="Catalog.aspx">Товары</a></li>
                    <li class="breadcrumb-item active" aria-current="page">
                        <asp:Label ID="lblProductNameBreadcrumb" runat="server" />
                    </li>
                </ol>
            </nav>
            <div class="align-self-end text-right">
                <asp:Label ID="lblMsg" runat="server" Visible="false"
                    CssClass="alert alert-success py-1 px-3 small d-inline-block shadow-sm" />
            </div>
            <!-- Карточка товара -->
            <div class="row">
                <!-- Фото -->
                <div class="col-md-6 mb-4 text-center">
                    <asp:Image ID="imgProduct" runat="server"
                        CssClass="img-fluid rounded shadow-sm border"
                        Style="max-width: 80%; height: auto;" />
                </div>
                <!-- Информация -->
                <div class="col-md-6">
                    <h2 class="mb-3">
                        <asp:Label ID="lblProductName" runat="server" />
                    </h2>
                    <h4 class="text-success mb-4">Цена:
                        <asp:Label ID="lblPrice" runat="server" />
                        сом
                    </h4>
                    <p class="text-muted mb-4">
                        <asp:Label ID="lblDescription" runat="server" />
                    </p>
                    <asp:Button ID="btnAddToCart" runat="server" CssClass="site-btn px-4" Text="Добавить в корзину" OnClick="btnAddToCart_Click" />
                </div>
            </div>
        </div>
    </section>
</asp:Content>
