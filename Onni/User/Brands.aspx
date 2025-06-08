<%@ Page Title="Бренды" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Brands.aspx.cs" Inherits="Onni.User.Brands" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-5">
        <h2 class="text-center mb-4">Бренды</h2>
        <div class="row">
            <asp:Repeater ID="rptBrands" runat="server">
                <ItemTemplate>
                    <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                        <a href='Catalog.aspx?brand=<%# Eval("BrandId") %>' class="brand-card-link text-decoration-none d-block h-100">
                            <div class="brand-card shadow-sm">
                                <div class="brand-card-img-wrapper">
                                    <img src='<%# ResolveUrl("../" + Eval("ImageUrl")) %>' alt='<%# Eval("Name") %>' />
                                </div>
                                <div class="brand-card-name">
                                    <%# Eval("Name") %>
                                </div>
                            </div>
                        </a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
