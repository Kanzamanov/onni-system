<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Contacts.aspx.cs" Inherits="Onni.Admin.Contacts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

    <script>
        /* For disappearing alert message */
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%= lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="pcoded-inner-content pt-0">
        <div class="align-align-self-end">
            <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
        </div>

        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-header">
                                </div>
                                <div class="card-block">
                                    <div class="row">
                                        <div class="col-12 mobile-inputs">
                                            <h4 class="sub-title">Список обращений</h4>
                                            <div class="card-block table-border-style">
                                                <div class="table-responsive">
                                                    <asp:Repeater ID="rContacts" runat="server" OnItemCommand="rContacts_ItemCommand">
                                                        <HeaderTemplate>
                                                            <table class="table data-table-export table-hover nowrap">
                                                                <thead>
                                                                    <tr>
                                                                        <th class="table-plus">№</th>
                                                                        <th>Имя пользователя</th>
                                                                        <th>Электронная почта</th>
                                                                        <th>Тема</th>
                                                                        <th>Сообщение</th>
                                                                        <th>Дата обращения</th>
                                                                        <th class="datatable-nosort">Удалить</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td class="table-plus"><%# Eval("SrNo") %></td>
                                                                <td><%# Eval("Name") %></td>
                                                                <td><%# Eval("Email") %></td>
                                                                <td><%# Eval("Subject") %></td>
                                                                <td><%# Eval("Message") %></td>
                                                                <td><%# Eval("CreatedDate") %></td>
                                                                <td>
                                                                    <asp:LinkButton ID="lnkDelete" runat="server"
                                                                        CssClass="badge bg-danger" ToolTip="Удалить сообщение"
                                                                        CommandArgument='<%# Eval("ContactId") %>' CommandName="delete"
                                                                        OnClientClick="return confirm('Вы уверены, что хотите удалить эту запись?');"
                                                                        CausesValidation="false"><i class="fas fa-trash"></i>
                                                                    </asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </tbody>
                                                            </table>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
